#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;
uniform float uStrokeWidth;
uniform float uPixelRatio;
uniform sampler2D uTexture;

out vec4 fragColor;

const int kMaxRadius = 6;

void main() {
    vec2 logicalSize = max(uSize, vec2(1.0));
    vec2 pixelSize = max(logicalSize * max(uPixelRatio, 1.0), vec2(1.0));
    vec2 texel = 1.0 / pixelSize;
    vec2 pixelCoord = floor(FlutterFragCoord().xy * max(uPixelRatio, 1.0));
    vec2 uv = (pixelCoord + 0.5) / pixelSize;
    // GLSL ES 2.0 compatible (Skia on Android < 10): no round(), no abs(int).
    float strokePixels = clamp(floor(uStrokeWidth * max(uPixelRatio, 1.0) + 0.5), 1.0, float(kMaxRadius));

    vec4 texColor = texture(uTexture, uv);
    float centerAlpha = step(0.5, texColor.a);
    float outlineAlpha = 0.0;

    for (int y = -kMaxRadius; y <= kMaxRadius; y++) {
        for (int x = -kMaxRadius; x <= kMaxRadius; x++) {
            if (abs(float(x)) > strokePixels || abs(float(y)) > strokePixels) {
                continue;
            }

            vec2 sampleUv = uv + vec2(float(x), float(y)) * texel;
            outlineAlpha = max(outlineAlpha, step(0.5, texture(uTexture, sampleUv).a));
        }
    }

    float strokeAlpha = max(0.0, outlineAlpha - centerAlpha);
    vec4 strokeColor = vec4(uColor.rgb, uColor.a * strokeAlpha);
    vec4 baseColor = vec4(texColor.rgb, centerAlpha);

    fragColor = mix(strokeColor, baseColor, centerAlpha);
}
