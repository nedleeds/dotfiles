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
// Noise helpers (minimal)
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

// ----------------------------
// Electric arc (LIGHT)
// ----------------------------
float electricArc(vec2 p, vec2 a, vec2 b, float time, float progress) {
    vec2 dir = b - a;
    float dist = length(dir);
    if (dist < 1e-5) return 1e5;
    dir /= dist;

    vec2 perp = vec2(-dir.y, dir.x);

    float t = clamp(dot(p - a, dir) / dist, 0.0, 1.0);
    vec2 projected = a + dir * (t * dist);

    float n1 = noise(vec2(t * 6.0,  time * 2.0));
    float n2 = noise(vec2(t * 12.0, time * 3.0));
    float jitter = (n1 - 0.5) * 0.030 + (n2 - 0.5) * 0.015;

    vec2 offset = perp * jitter * progress;
    return length(p - (projected + offset));
}

// ----------------------------
// Colors / params
// ----------------------------
const vec4 TRAIL_COLOR_ACCENT = vec4(0.705, 0.831, 0.957, 1.0);
const vec4 ELECTRIC_COLOR     = vec4(0.5, 0.8, 1.0, 1.0);

const float DURATION      = 0.9;
const float TAIL_EXTENSION = 0.6;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Keep the underlying content (cursor style should come from outside this shader pipeline)
    #if !defined(WEB)
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #else
    vec4 base = fragColor;
    #endif

    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor  = vec4(normalize(iCurrentCursor.xy, 1.),  normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    vec2 centerCP_new = centerCP + (centerCP - centerCC) * TAIL_EXTENSION;

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float easedProgress = ease(progress);

    // If there's effectively no animation, just passthrough
    if (easedProgress <= 0.0001) {
        fragColor = base;
        return;
    }

    float lineLength = distance(centerCC, centerCP_new);
    float distanceToEnd = distance(vu.xy, centerCC);
    float alphaModifier = distanceToEnd / max(lineLength * easedProgress, 1e-4);
    alphaModifier = min(alphaModifier, 1.0);

    // taper along tail
    float trailOpacity = pow(
        1.0 - smoothstep(0.0, 1.0, alphaModifier),
        2.2
    );
    // arc
    float arcThickness = 0.0025;
    float arc = electricArc(vu, centerCC, centerCP_new, iTime, easedProgress);

    float core = 1.0 - smoothstep(arcThickness * 0.6, arcThickness, arc);
    float glow = 1.0 - smoothstep(arcThickness * 2.0, arcThickness * 5.0, arc);

    float strength = trailOpacity * 0.55;

    // very subtle shimmer
    float shimmer = 0.92 + 0.08 * sin(iTime * 8.0);
    vec3 arcRGB = mix(ELECTRIC_COLOR.rgb, TRAIL_COLOR_ACCENT.rgb, 0.25) * shimmer;

    // Additive-like compositing (doesn't overwrite cursor; it just adds light)
    // Clamp to avoid blowing out highlights too much.
    vec3 added = arcRGB * (core * strength + glow * strength * 0.15);
    vec3 outRGB = clamp(base.rgb + added, 0.0, 1.0);

    fragColor = vec4(outRGB, base.a);
}
