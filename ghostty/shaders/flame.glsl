// =========================================================
// Ghostty Cursor Shader: Fire Afterimage Tail ONLY (no particles)
// - Thor lightningArc shape
// - Ember / fire palette (hot core -> orange glow -> deep red)
// - Instant visibility on movement
// - Only the afterimage/glow "settles" slowly (build)
// - Smooth flicker, no popping
// =========================================================

float ease(float x) { return pow(1.0 - x, 10.0); }

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t) {
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.0), rectangle.y - (rectangle.w / 2.0));
}

// ----------------------------
// Noise helpers
// ----------------------------
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    mat2 m = mat2(1.6, 1.2, -1.2, 1.6);
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p = m * p;
        a *= 0.5;
    }
    return v;
}

// ----------------------------
// Lightning distance field
// ----------------------------
float lightningArc(vec2 p, vec2 a, vec2 b, float time, float progress, out float tAlong) {
    vec2 dir = b - a;
    float dist = length(dir);
    if (dist < 1e-5) { tAlong = 0.0; return 1e5; }
    dir /= dist;

    vec2 perp = vec2(-dir.y, dir.x);

    float t = clamp(dot(p - a, dir) / dist, 0.0, 1.0);
    tAlong = t;

    vec2 projected = a + dir * (t * dist);

    float w1 = fbm(vec2(t * 10.0, time * 2.6));
    float w2 = fbm(vec2(t * 22.0 + w1 * 1.5, time * 4.2));
    float w3 = noise(vec2(t * 48.0 + w2 * 2.0, time * 7.0));

    float mid = 1.0 - abs(2.0 * t - 1.0);
    float jag = (0.55 + 0.45 * mid);

    // Slightly reduced amplitude vs "electric", more afterimage-like
    float amp = (0.022 * jag) + (0.014 * jag) * (w2 - 0.5);

    // Still keep kinks, but milder
    float stepper = floor((w1 + w3) * 6.0) / 6.0;
    float kink = (stepper - 0.5) * 0.014;

    float jitter = ((w2 - 0.5) * amp + kink) * progress;
    float alongWarp = (w3 - 0.5) * 0.008 * progress;

    vec2 warped = projected + perp * jitter + dir * alongWarp;
    return length(p - warped);
}

// ----------------------------
// Fire palette for tail (no particles)
// ----------------------------
vec3 fireOuter(float heat) {
    // heat: 0 cool -> 1 hot
    vec3 deep   = vec3(0.62, 0.06, 0.02);
    vec3 orange = vec3(1.00, 0.34, 0.08);
    vec3 yellow = vec3(1.00, 0.80, 0.20);
    return mix(deep, mix(orange, yellow, 0.55), heat);
}

vec3 fireCore(float heat) {
    vec3 white  = vec3(1.00);
    vec3 yellow = vec3(1.00, 0.88, 0.35);
    return mix(yellow, white, heat);
}

// ----------------------------
// Params
// ----------------------------
const float DURATION       = 1.25;   // tail event duration
const float MAX_TAIL       = 0.28;
const float TAIL_EXTENSION = 0.60;

const float TAIL_BASE      = 0.22;
const float TAPER_POW      = 1.55;

// Thickness and glow
const float THICKNESS      = 0.0020;
const float GLOW_SCALE     = 7.0;

// Strength weights (no particles, so tail can be richer)
const float CORE_GAIN      = 0.95;
const float GLOW_GAIN      = 0.53;
const float BRANCH_GAIN    = 0.22;
const float SPARK_GAIN     = 0.90;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    #if !defined(WEB)
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #else
    vec4 base = fragColor; 
    #endif

    vec2 vu = normalize(fragCoord, 1.0);

    vec4 currentCursor  = vec4(normalize(iCurrentCursor.xy, 1.0),  normalize(iCurrentCursor.zw, 0.0));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.0), normalize(iPreviousCursor.zw, 0.0));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float eased = ease(progress);

    if (eased <= 0.0001) {
        fragColor = base;
        return;
    }

    vec2 seg = centerCP - centerCC;
    float segLen = length(seg);
    if (segLen < 0.0012) {
        fragColor = base;
        return;
    }

    vec2 dir  = seg / segLen;
    vec2 perp = vec2(-dir.y, dir.x);

    // Clamp tail
    float clampedLen = min(segLen, MAX_TAIL);
    vec2 centerCP_c = centerCC + dir * clampedLen;
    vec2 tailEnd = centerCP_c + (centerCP_c - centerCC) * TAIL_EXTENSION;
    float tailLen = distance(centerCC, tailEnd);

    // Tail taper (immediate visibility)
    float distanceToHead = distance(vu, centerCC);
    float alphaModifier = distanceToHead / max(tailLen * eased, 1e-4);
    alphaModifier = min(alphaModifier, 1.0);

    float trailOpacity = pow(1.0 - smoothstep(0.0, 1.0, alphaModifier), TAPER_POW);
    trailOpacity = max(trailOpacity, TAIL_BASE);

    // Life: linger
    float life = pow(1.0 - progress, 0.62);

    // Only afterimage glow/branches settle slowly
    float settle = smoothstep(0.00, 0.55, progress);

    // Compute arc distance
    float tAlong = 0.0;
    float arc = lightningArc(vu, centerCC, tailEnd, iTime, eased, tAlong);

    // Flicker: fire-like, less "electric sine", more irregular
    float head = smoothstep(1.0, 0.0, tAlong);
    float flick1 = 0.75 + 0.25 * noise(vec2(iTime * 28.0, tAlong * 10.0));
    float flick2 = 0.80 + 0.20 * noise(vec2(iTime * 60.0, tAlong * 4.0 + 7.3));
    float energy = flick1 * flick2 * (0.72 + 0.28 * head);

    // Thickness: sharp core + wide glow
    float core = 1.0 - smoothstep(THICKNESS * 0.45, THICKNESS, arc);
    float glow = 1.0 - smoothstep(THICKNESS * 1.6, THICKNESS * GLOW_SCALE, arc);

    // Micro-branches (subtle)
    float branchShift = (noise(vec2(tAlong * 50.0, iTime * 10.0)) - 0.5) * 0.009 * eased;
    float tDummy = 0.0;
    float arc2 = lightningArc(vu + vec2(branchShift, -branchShift), centerCC, tailEnd,
                              iTime + 0.03, eased * 0.72, tDummy);
    float branch = 1.0 - smoothstep(THICKNESS * 0.70, THICKNESS * 1.7, arc2);

    // Hotspots along arc (reads as "embers" without particles)
    float sparkN = noise(vec2(tAlong * 90.0, iTime * 18.0));
    float sparks = smoothstep(0.90, 1.0, sparkN);
    sparks *= (1.0 - smoothstep(0.0, 1.0, alphaModifier));
    sparks *= (0.60 + 0.40 * (1.0 - abs(2.0 * tAlong - 1.0)));

    float strength = trailOpacity * life * energy;

    // Heat profile: hotter near head, cooler toward tail
    float heat = clamp(0.85 * head + 0.15, 0.0, 1.0);

    vec3 outerRGB = fireOuter(heat);
    vec3 coreRGB  = fireCore(heat);

    // Compose:
    // - core immediate
    // - glow/branch settle slowly
    vec3 added =
        coreRGB  * (core   * strength * CORE_GAIN) +
        outerRGB * (glow   * strength * GLOW_GAIN   * settle) +
        outerRGB * (branch * strength * BRANCH_GAIN * settle) +
        vec3(1.0) * (sparks * strength * SPARK_GAIN);

    vec3 outRGB = clamp(base.rgb + added, 0.0, 1.0);
    fragColor = vec4(outRGB, base.a);
}
