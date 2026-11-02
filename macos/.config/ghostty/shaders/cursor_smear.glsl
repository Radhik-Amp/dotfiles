// credit: https://github.com/hackrdotsh/ghostty-shaders

const float DECAY_FAST = 0.08;      // lead corners (s)
const float DECAY_SLOW = 0.40;      // trail corners (s)
const float START_THRESHOLD = 2.0;  // min jump (cells)
const float OPACITY = 1.0;

const bool USE_CURSOR_COLOR = true; // false = TRAIL_COLOR
const vec4 TRAIL_COLOR = vec4(0.980, 0.741, 0.184, 1.0); // gruvbox yellow

// quad SDF (iq)
float sdQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    vec2 v[4] = vec2[4](v0, v1, v2, v3);
    float d = dot(p - v[0], p - v[0]);
    float s = 1.0;
    for (int i = 0, j = 3; i < 4; j = i, i++) {
        vec2 e = v[j] - v[i];
        vec2 w = p - v[i];
        vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));
        bvec3 c = bvec3(p.y >= v[i].y, p.y < v[j].y, e.x * w.y > e.y * w.x);
        if (all(c) || all(not(c))) s *= -1.0;
    }
    return s * sqrt(d);
}

float travelled(float t, float decay) {
    return 1.0 - exp2(-10.0 * t / decay);
}

// TL, TR, BR, BL
vec2 corner(vec4 r, int i) {
    vec2 o = (i == 0) ? vec2(0.0, 0.0)
           : (i == 1) ? vec2(r.z, 0.0)
           : (i == 2) ? vec2(r.z, -r.w)
           :            vec2(0.0, -r.w);
    return r.xy + o;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    float t = iTime - iTimeCursorChange;
    if (t > DECAY_SLOW) return;

    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    if (cur.z < 1.0 || cur.w < 1.0) return;

    vec2 curCenter = cur.xy + vec2(cur.z, -cur.w) * 0.5;
    vec2 prevCenter = prev.xy + vec2(prev.z, -prev.w) * 0.5;
    vec2 delta = curCenter - prevCenter;

    vec2 cells = abs(delta) / cur.zw;
    if (max(cells.x, cells.y) < START_THRESHOLD) return;

    // skip cursor cell
    vec2 local = fragCoord - cur.xy;
    if (local.x >= 0.0 && local.x <= cur.z && local.y <= 0.0 && local.y >= -cur.w) return;

    vec2 dir = normalize(delta);
    vec2 c[4];
    float slowest = 1.0;
    for (int i = 0; i < 4; i++) {
        vec2 target = corner(cur, i);
        vec2 start = corner(prev, i);
        float lead = dot(normalize(target - curCenter), dir) * 0.5 + 0.5; // 1 = leading
        float f = travelled(t, mix(DECAY_SLOW, DECAY_FAST, lead));
        slowest = min(slowest, f);
        c[i] = mix(start, target, f);
    }

    float d = sdQuad(fragCoord, c[0], c[1], c[2], c[3]);
    float coverage = 1.0 - smoothstep(-0.5, 0.5, d); // 1px AA
    float alpha = coverage * OPACITY * (1.0 - slowest);

    vec4 color = USE_CURSOR_COLOR ? iCurrentCursorColor : TRAIL_COLOR;
    fragColor = mix(fragColor, vec4(color.rgb, 1.0), alpha);
}
