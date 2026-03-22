// ==========================================
// Optimized Thor Lightning Shader for Ghostty
// ==========================================

float ease(float x) {
    float x2 = 1.0 - x;
    float x4 = x2 * x2;
    return x4 * x4 * x2;
}

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
// Noise helpers (성능 최적화)
// ----------------------------
float random(vec2 p) {
    vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm_fast(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    mat2 m = mat2(1.6, 1.2, -1.2, 1.6);
    for (int i = 0; i < 3; i++) {
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

    float w1 = fbm_fast(vec2(t * 10.0, time * 2.6));
    float w2 = fbm_fast(vec2(t * 22.0 + w1 * 1.5, time * 4.2));

    float mid = 1.0 - abs(2.0 * t - 1.0);
    float jag = (0.55 + 0.45 * mid);
    float amp = (0.030 * jag) + (0.020 * jag) * (w2 - 0.5);

    float jitter = (w2 - 0.5) * amp * progress * 2.0;

    vec2 warped = projected + perp * jitter;
    return length(p - warped);
}

// ----------------------------
// Colors / params
// ----------------------------
const vec4 TRAIL_COLOR_ACCENT = vec4(0.705, 0.831, 0.957, 1.0);
const vec4 ELECTRIC_COLOR     = vec4(0.50, 0.82, 1.00, 1.0);

const float DURATION       = 0.9;
const float TAIL_EXTENSION = 0.6;

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
    vec2 centerCP_new = centerCP + (centerCP - centerCC) * TAIL_EXTENSION;

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float easedProgress = ease(progress);

    if (easedProgress <= 0.0001 || distance(centerCC, centerCP) < 0.001) {
        fragColor = base;
        return;
    }

    vec2 minBounds = min(centerCC, centerCP_new) - vec2(0.2);
    vec2 maxBounds = max(centerCC, centerCP_new) + vec2(0.2);
    if (vu.x < minBounds.x || vu.x > maxBounds.x || vu.y < minBounds.y || vu.y > maxBounds.y) {
        fragColor = base;
        return;
    }

    float lineLength = distance(centerCC, centerCP_new);
    float distanceToEnd = distance(vu.xy, centerCC);
    float alphaModifier = distanceToEnd / max(lineLength * easedProgress, 1e-4);
    alphaModifier = min(alphaModifier, 1.0);

    float trailOpacity = pow(1.0 - smoothstep(0.0, 1.0, alphaModifier), 2.0);

    float tAlong = 0.0;
    float arc = lightningArc(vu, centerCC, centerCP_new, iTime, easedProgress, tAlong);

    float head = smoothstep(1.0, 0.0, tAlong);
    float flicker = 0.70 + 0.30 * noise(vec2(iTime * 35.0, tAlong * 9.0));
    float pulse   = 0.85 + 0.15 * sin(iTime * 28.0 + tAlong * 22.0);
    float energy  = flicker * pulse * (0.75 + 0.25 * head);

    float arcThickness = 0.0005;
    float core = 1.0 - smoothstep(arcThickness * 0.45, arcThickness, arc);
    float glow = 1.0 - smoothstep(arcThickness * 1.8, arcThickness * 7.0, arc);

    float fakeBranch = glow * (noise(vec2(tAlong * 50.0, iTime * 20.0)) - 0.4);
    float branch = max(0.0, fakeBranch);

    float sparkN = noise(vec2(tAlong * 80.0, iTime * 16.0));
    float sparks = smoothstep(0.92, 1.0, sparkN) * (1.0 - smoothstep(0.0, 1.0, alphaModifier));
    sparks *= (1.0 - smoothstep(0.0, 0.15, abs(tAlong - 0.5)));

    // --- 화력 지원 버전 색상 및 최종 합성 ---
    float boostedStrength = trailOpacity * energy * 1.5;

    vec3 outerRGB = mix(ELECTRIC_COLOR.rgb, TRAIL_COLOR_ACCENT.rgb, 0.2);
    vec3 coreRGB  = vec3(1.0);

    vec3 added =
        coreRGB  * (core * boostedStrength * 1.2) +
        outerRGB * (glow * boostedStrength * 0.35) +
        outerRGB * (branch * boostedStrength * 1.2) +
        vec3(1.0) * (sparks * boostedStrength * 0.75);

    float effectMask = clamp(length(added), 0.0, 1.0);
    float effectOpacity = 0.85;

    vec3 outRGB = mix(base.rgb, added, effectMask * effectOpacity);
    outRGB = clamp(outRGB + added * 0.2, 0.0, 1.0);

    fragColor = vec4(outRGB, base.a);
}
