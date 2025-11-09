shader_type canvas_item;

uniform vec4 from_palette[8] : source_color;
uniform vec4 to_palette[8]   : source_color;
uniform int palette_size : hint_range(1, 64) = 8;
uniform float tolerance : hint_range(0.1, 0.5) = 0.01;

void fragment() {
    vec4 src = texture(TEXTURE, UV);
    vec4 final_color = src;

    for (int i = 0; i < palette_size; i++) {
        if (distance(src.rgb, from_palette[i].rgb) < tolerance) {
            final_color = vec4(to_palette[i].rgb, src.a * to_palette[i].a);
            break;
        }
    }

    COLOR = final_color;
}
