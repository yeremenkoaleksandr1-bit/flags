#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;

out vec4 fragColor;

void main() {
    vec2 size = max(uSize, vec2(1.0));
    vec2 uv = FlutterFragCoord().xy / size;

    float verticalLight = mix(1.18, 0.88, uv.y);
    float horizontalLight = mix(1.06, 0.96, uv.x);
    vec3 color = clamp(uColor.rgb * verticalLight * horizontalLight, 0.0, 1.0);

    fragColor = vec4(color, uColor.a);
}
