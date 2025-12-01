shader_type canvas_item;

uniform float fill : hint_range(0.0, 1.0) = 1.0;

uniform vec4 from_palette[8] : source_color;
uniform vec4 to_palette[8] : source_color;
uniform int palette_size : hint_range(1, 64) = 8;
uniform float tolerance : hint_range(0.001, 0.2) = 0.01;

void fragment() {
    // --- Circular mask ---
    vec2 uv = UV * 2.0 - 1.0;

    // Ángulo original (empieza a la derecha)
    float angle = atan(uv.y, uv.x);

    // Rotamos +90° para empezar arriba (12 en punto)
    angle += PI * 1.5; // PI * 0.5

    // Normalizamos a 0..1
    float norm_angle = fract((angle + 3.1415926) / (2.0 * 3.1415926));

    float dist = length(uv);
    float mask = (dist <= 1.0 && norm_angle <= fill) ? 1.0 : 0.0;

    // --- Texture sample ---
    vec4 src = texture(TEXTURE, UV);

    // --- Palette swap ---
    vec4 final_color = src;
    for (int i = 0; i < palette_size; i++) {
        if (distance(src.rgb, from_palette[i].rgb) < tolerance) {
            final_color = vec4(to_palette[i].rgb, src.a * to_palette[i].a);
            break;
        }
    }

    COLOR = vec4(final_color.rgb, final_color.a * mask);
}
