float ease(float x) { return pow(1.0 - x, 10.0); }

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t) {
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
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
// - returns distance to a warped, jagged arc line
// ----------------------------
float lightningArc(vec2 p, vec2 a, vec2 b, float time, float progress, out float tAlong) {
    vec2 dir = b - a;
    float dist = length(dir);
    if (dist < 1e-5) { tAlong = 0.0; return 1e5; }
    dir /= dist;

    vec2 perp = vec2(-dir.y, dir.x);

    float t = clamp(dot(p - a, dir) / dist, 0.0, 1.0);
    tAlong = t;

    // base projection on segment
    vec2 projected = a + dir * (t * dist);

    // --- make it more "lightning" ---
    // strong, fractal jitter with a little domain warp
    float w1 = fbm(vec2(t * 10.0, time * 2.6));
    float w2 = fbm(vec2(t * 22.0 + w1 * 1.5, time * 4.2));
    float w3 = noise(vec2(t * 48.0 + w2 * 2.0, time * 7.0));

    // jaggedness profile: stronger near middle, softer near ends
    float mid = 1.0 - abs(2.0 * t - 1.0); // 0..1..0
    float jag = (0.55 + 0.45 * mid);

    // amplitude also scales with progress
    float amp = (0.030 * jag) + (0.020 * jag) * (w2 - 0.5);

    // "steppy" effect: quantize a component to get sharp kinks
    float stepper = floor((w1 + w3) * 7.0) / 7.0;
    float kink = (stepper - 0.5) * 0.020;

    float jitter = ((w2 - 0.5) * amp + kink) * progress;

    // small along-dir warp to avoid too smooth appearance
    float alongWarp = (w3 - 0.5) * 0.010 * progress;

    vec2 warped = projected + perp * jitter + dir * alongWarp;

    return length(p - warped);
}

// ----------------------------
// Colors / params
// ----------------------------
const vec4 TRAIL_COLOR_ACCENT = vec4(0.705, 0.831, 0.957, 1.0);
const vec4 ELECTRIC_COLOR     = vec4(0.50, 0.82, 1.00, 1.0);

// tweakables
const float DURATION       = 0.9;
const float TAIL_EXTENSION = 0.6;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    #if !defined(WEB)
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #else
    vec4 base = fragColor;
    #endif

    vec2 vu = normalize(fragCoord, 1.);

    vec4 currentCursor  = vec4(normalize(iCurrentCursor.xy, 1.),  normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    vec2 centerCP_new = centerCP + (centerCP - centerCC) * TAIL_EXTENSION;

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float easedProgress = ease(progress);

    if (easedProgress <= 0.0001) {
        fragColor = base;
        return;
    }

    // tail taper
    float lineLength = distance(centerCC, centerCP_new);
    float distanceToEnd = distance(vu.xy, centerCC);
    float alphaModifier = distanceToEnd / max(lineLength * easedProgress, 1e-4);
    alphaModifier = min(alphaModifier, 1.0);

    float trailOpacity = pow(1.0 - smoothstep(0.0, 1.0, alphaModifier), 2.0);

    // --- lightning computation ---
    float tAlong = 0.0;
    float arc = lightningArc(vu, centerCC, centerCP_new, iTime, easedProgress, tAlong);

    // flicker/pulse: irregular and stronger near the head
    float head = smoothstep(1.0, 0.0, tAlong);          // 1 near start (a), 0 near end (b) depending on direction
    float flicker = 0.70 + 0.30 * noise(vec2(iTime * 35.0, tAlong * 9.0));
    float pulse   = 0.85 + 0.15 * sin(iTime * 28.0 + tAlong * 22.0);
    float energy  = flicker * pulse * (0.75 + 0.25 * head);

    // thickness: core sharper, glow wider
    float arcThickness = 0.0022;
    float core = 1.0 - smoothstep(arcThickness * 0.45, arcThickness, arc);
    float glow = 1.0 - smoothstep(arcThickness * 1.8, arcThickness * 7.0, arc);

    // micro-branches (very subtle): sample a nearby shifted arc to look like a side spark
    // NOTE: cheap approximation, still "light"
    float branchShift = (noise(vec2(tAlong * 50.0, iTime * 10.0)) - 0.5) * 0.010 * easedProgress;
    float tDummy = 0.0;
    float arc2 = lightningArc(vu + vec2(branchShift, -branchShift), centerCC, centerCP_new, iTime + 0.03, easedProgress * 0.75, tDummy);
    float branch = 1.0 - smoothstep(arcThickness * 0.65, arcThickness * 1.6, arc2);

    // hotspots / sparks along the arc
    float sparkN = noise(vec2(tAlong * 80.0, iTime * 16.0));
    float sparks = smoothstep(0.92, 1.0, sparkN) * (1.0 - smoothstep(0.0, 1.0, alphaModifier));
    sparks *= (1.0 - smoothstep(0.0, 0.15, abs(tAlong - 0.5))); // bias toward mid a bit

    float strength = trailOpacity * 0.75 * energy;

    // color: core trends to white, outer to cyan/blue
    vec3 outerRGB = mix(ELECTRIC_COLOR.rgb, TRAIL_COLOR_ACCENT.rgb, 0.25);
    vec3 coreRGB  = mix(vec3(1.0), outerRGB, 0.35);

    // compose: core + glow + branch + sparks
    vec3 added =
        coreRGB  * (core * strength) +
        outerRGB * (glow * strength * 0.22) +
        outerRGB * (branch * strength * 0.18) +
        vec3(1.0) * (sparks * strength * 0.35);

    vec3 outRGB = clamp(base.rgb + added, 0.0, 1.0);
    fragColor = vec4(outRGB, base.a);
}
