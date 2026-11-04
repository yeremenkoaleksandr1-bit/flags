#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;
uniform float uStrokeWidth;
uniform float uPixelRatio;
uniform sampler2D uTexture;

out vec4 fragColor;

const int kMaxRadius = 8;

float sampleAlpha(vec2 uv) {
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        return 0.0;
    }
    return texture(uTexture, uv).a;
}

void main() {
    vec2 logicalSize = max(uSize, vec2(1.0));
    vec2 pixelSize = max(logicalSize * max(uPixelRatio, 1.0), vec2(1.0));
    vec2 texel = 1.0 / pixelSize;
    vec2 pixelCoord = floor(FlutterFragCoord().xy * max(uPixelRatio, 1.0));
    vec2 uv = (pixelCoord + 0.5) / pixelSize;

    float baseAlpha = step(0.01, sampleAlpha(uv));

    // GLSL ES 2.0 compatible (Skia on Android < 10): no round().
    int radius = int(clamp(floor(uStrokeWidth * max(uPixelRatio, 1.0) + 0.5), 1.0, float(kMaxRadius)));
    float outlineAlpha = 0.0;

    for (int y = -kMaxRadius; y <= kMaxRadius; y++) {
        for (int x = -kMaxRadius; x <= kMaxRadius; x++) {
            if (x * x + y * y > radius * radius) {
                continue;
            }

            vec2 sampleUv = uv + vec2(float(x), float(y)) * texel;
            outlineAlpha = max(outlineAlpha, step(0.01, sampleAlpha(sampleUv)));
        }
    }

    float strokeAlpha = max(0.0, outlineAlpha - baseAlpha) * uColor.a;
    fragColor = vec4(uColor.rgb * strokeAlpha, strokeAlpha);
}
