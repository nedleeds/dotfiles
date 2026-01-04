// =========================================================
// lava_particle.glsl (Ghostty cursor shader)
// - Cursor-only: ember-like particles + lava shimmer trail
// - Tail size comparable to the earlier lightning shader
// - No background effects; additive only; cursor style preserved
// - Robust: clamps tail length to avoid screen-wide streaks on big jumps
// =========================================================

// ----------------------------
// Core helpers (kept from your style)
// ----------------------------
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
// Noise / hash (stable)
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

float hash11(float n) {
    return fract(sin(n) * 43758.5453123);
}

// ----------------------------
// Geometry helpers
// ----------------------------
float sdCircle(vec2 p, vec2 c, float r) {
    return length(p - c) - r;
}

float softParticle(vec2 p, vec2 c, float r) {
    float d = length(p - c);
    float core = 1.0 - smoothstep(0.0, r, d);
    float halo = 1.0 - smoothstep(r, r * 3.5, d);
    return core * 0.85 + halo * 0.20;
}

// ----------------------------
// Lava palette (restrained, ember-friendly)
// ----------------------------
vec3 lavaPalette(float heat) {
    // heat: 0..1
    vec3 dark  = vec3(0.14, 0.03, 0.02); // deep red-brown
    vec3 red   = vec3(0.60, 0.10, 0.04);
    vec3 orange= vec3(0.95, 0.30, 0.06);
    vec3 yellow= vec3(1.00, 0.82, 0.22);
    vec3 white = vec3(1.00, 1.00, 1.00);

    vec3 c = mix(dark, red,    smoothstep(0.05, 0.25, heat));
    c = mix(c, orange,         smoothstep(0.20, 0.60, heat));
    c = mix(c, yellow,         smoothstep(0.55, 0.90, heat));
    c = mix(c, white,          smoothstep(0.92, 1.00, heat) * 0.40);
    return c;
}

// =========================================================
// Tail distance: "lava ribbon" (like lightning sizing, but molten)
// =========================================================
float lavaRibbonDist(vec2 p, vec2 a, vec2 b, float time, float progress, out float tAlong) {
    vec2 dir = b - a;
    float dist = length(dir);
    if (dist < 1e-5) { tAlong = 0.0; return 1e5; }
    dir /= dist;

    vec2 perp = vec2(-dir.y, dir.x);

    float t = clamp(dot(p - a, dir) / dist, 0.0, 1.0);
    tAlong = t;
    vec2 projected = a + dir * (t * dist);

    // molten wobble: slower, thicker, less "electric"
    float w1 = fbm(vec2(t * 6.0,  time * 0.9));
    float w2 = fbm(vec2(t * 13.0 + w1 * 1.3, time * 1.6));
    float wob = (w2 - 0.5) * 2.0;

    // stronger near mid; calmer near ends
    float mid = 1.0 - abs(2.0 * t - 1.0);
    float profile = 0.55 + 0.45 * mid;

    // amplitude scaled by progress (tail "forms" then cools)
    float amp = 0.020 * profile * progress;

    // add slight stepping to suggest viscous "chunks" without looking noisy
    float stepper = floor((w1 + w2) * 6.0) / 6.0;
    float kink = (stepper - 0.5) * 0.010 * progress;

    vec2 warped = projected + perp * (wob * amp + kink);

    return length(p - warped);
}

// =========================================================
// Tunables (match lightning-size tail; lava look via color/heat)
// =========================================================
const float DURATION        = 0.90;  // similar to lightning
const float TAIL_EXTENSION  = 0.60;  // similar to lightning
const float MAX_TAIL_LEN    = 0.52;  // prevent screen-wide streaks on big jumps

// ribbon thickness (roughly comparable to lightning arcThickness scale)
const float RIBBON_THICK    = 0.0028;

// embers: subtle, not confetti
const int   EMBER_COUNT     = 82;
const float EMBER_INTENSITY = 0.58;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // base
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

    // no animation: passthrough
    if (eased <= 0.0001) {
        fragColor = base;
        return;
    }

    // Movement vector
    vec2 move = centerCP - centerCC;
    float moveLen = length(move);
    if (moveLen < 0.0016) {
        fragColor = base;
        return;
    }

    vec2 moveDir = move / moveLen;
    vec2 perp = vec2(-moveDir.y, moveDir.x);

    // Clamp tail length, then extend like the lightning version
    float clampedLen = min(moveLen, MAX_TAIL_LEN);
    vec2 centerCP_clamped = centerCC + moveDir * clampedLen;

    vec2 tailEnd = centerCP_clamped + (centerCP_clamped - centerCC) * TAIL_EXTENSION;

    // Tail taper (same idea as lightning: fade along length)
    float lineLength = distance(centerCC, tailEnd);
    float distanceToEnd = distance(vu, centerCC);
    float alphaModifier = distanceToEnd / max(lineLength * eased, 1e-4);
    alphaModifier = min(alphaModifier, 1.0);

    float tailOpacity = pow(1.0 - smoothstep(0.0, 1.0, alphaModifier), 2.15);

    // Early-out far from the tube to avoid affecting the whole screen
    float distToAxis = abs(dot(vu - centerCC, perp));
    if (distToAxis > RIBBON_THICK * 12.0) {
        fragColor = base;
        return;
    }

    // ----------------------------
    // Lava ribbon
    // ----------------------------
    float tAlong = 0.0;
    float d = lavaRibbonDist(vu, centerCC, tailEnd, iTime, eased, tAlong);

    // core + glow (similar sizing to lightning, but softer glow)
    float core = 1.0 - smoothstep(RIBBON_THICK * 0.55, RIBBON_THICK, d);
    float glow = 1.0 - smoothstep(RIBBON_THICK * 1.6, RIBBON_THICK * 6.0, d);

    // molten "heat" pattern along the ribbon (hot spots)
    float hot = fbm(vec2(tAlong * 10.0, iTime * 0.9)) * 0.55
              + fbm(vec2(tAlong * 22.0 + 2.0, iTime * 1.6)) * 0.45;
    hot = clamp(hot, 0.0, 1.0);

    // hotter near the head, cooler toward tail
    float headBoost = (1.0 - tAlong);
    float heat = clamp(core * (0.55 + 0.55 * hot) * (0.70 + 0.30 * headBoost), 0.0, 1.0);

    // subtle flicker (molten simmer, not strobe)
    float simmer = 0.92 + 0.08 * noise(vec2(iTime * 8.0, tAlong * 9.0));

    // ribbon strength tied to tailOpacity, and fades with eased
    float ribbonStrength = tailOpacity * simmer;

    vec3 lavaCol = lavaPalette(heat);

    vec3 ribbonAdd = lavaCol * (core * ribbonStrength * 0.70 + glow * ribbonStrength * 0.18);

    // ----------------------------
    // Embers: particle-only "spark" feel (no other particle field)
    // - warm colors, small sizes, biased toward mid-tail
    // ----------------------------
    float eventId = floor(iTimeCursorChange * 120.0 + 0.5);
    vec3 emberAdd = vec3(0.0);

    // embers should only exist where the tail exists
    float life = pow(1.0 - progress, 1.6);

    for (int i = 0; i < EMBER_COUNT; i++) {
        float fi = float(i);

        float r0 = hash11(eventId + fi * 11.13);
        float r1 = hash11(eventId + fi * 23.71);
        float r2 = hash11(eventId + fi * 37.97);

        // place along tail; avoid too close to head to prevent "cursor glow blob"
        float tt = mix(0.18, 1.0, pow(r0, 0.75));
        vec2 onTail = mix(centerCC, tailEnd, tt);

        // scatter around the ribbon tube, slightly more scatter toward tail
        float spread = mix(RIBBON_THICK * 1.8, RIBBON_THICK * 6.0, tt);
        float lateral = (r1 - 0.5) * 2.0 * spread;

        // small drift backward as time progresses (embers "lag")
        float drift = (0.006 + 0.018 * r2) * (1.0 - progress);
        float jitter = (hash11(eventId + fi * 9.31 + 3.0) - 0.5) * 0.004;

        vec2 c = onTail + perp * (lateral + jitter) + moveDir * (drift * 0.55);

        // size: tiny, with occasional brighter sparks
        float spark = smoothstep(0.88, 1.0, r2);
        float size = mix(0.0011, 0.0024, (1.0 - tt)) * (0.85 + 0.40 * spark);

        float m = softParticle(vu, c, size);

        // ember visibility fades with tailOpacity and life
        float p = m * life * tailOpacity * (0.55 + 0.60 * spark);

        // ember color: deep orange -> yellow-white for sparks
        vec3 emberCol = mix(vec3(0.95, 0.30, 0.06), vec3(1.00, 0.88, 0.22), spark);
        emberAdd += emberCol * (p * EMBER_INTENSITY);
    }

    // Total additive (no other effects)
    vec3 added = ribbonAdd + emberAdd;

    vec3 outRGB = clamp(base.rgb + added, 0.0, 1.0);
    fragColor = vec4(outRGB, base.a);
}
