shader_type canvas_item;

uniform float outline_size = 1.0; // tamaño del outline en píxeles (1.0 = 1px)
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.4, 1.0);
uniform float glow_strength = 1.0; // multiplicador de alpha para el outline

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	float base_alpha = base.a;

	// Chequeamos vecinos (fixed -1..1 para pixel-perfect). 
	// Multiplicamos por TEXTURE_PIXEL_SIZE para moverse en unidades de UV por píxel.
	float neighbor_alpha = 0.0;
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * outline_size * TEXTURE_PIXEL_SIZE;
			vec4 s = texture(TEXTURE, UV + offset);
			neighbor_alpha = max(neighbor_alpha, s.a);
		}
	}

	// Si el pixel original existe, lo dibujamos normal
	if (base_alpha > 0.0) {
		COLOR = base;
	} 
	// Si el pixel está vacío pero algún vecino tiene alpha -> outline
	else if (neighbor_alpha > 0.0) {
		// Usamos neighbor_alpha para atenuar el alpha del outline (evita bordes sólidos demasiados duros)
		float a = clamp(neighbor_alpha * glow_strength, 0.0, 1.0);
		COLOR = vec4(outline_color.rgb, a);
	} 
	// Transparencia completa si nada
	else {
		COLOR = vec4(0.0);
	}
}
