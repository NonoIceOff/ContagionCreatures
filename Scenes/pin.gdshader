shader_type canvas_item;

uniform float glow_intensity = 1.0; // Intensité du glow
uniform vec4 glow_color = vec4(1.0, 1.0, 1.0, 1.0); // Couleur du glow
uniform float glow_size = 10.0; // Taille du glow

void fragment() {
	// Texture de base
	vec4 base_texture = texture(TEXTURE, UV);
	vec4 glow = vec4(0.0);

	// Échantillonnage élargi pour générer le glow autour de la texture
	for (int x = -5; x <= 5; x++) {
		for (int y = -5; y <= 5; y++) {
			vec2 offset = vec2(float(x), float(y)) * glow_size / 100.0;
			vec4 sampled = texture(TEXTURE, UV + offset);

			// Ajoute au glow uniquement si le pixel voisin appartient à la texture
			if (sampled.a > 0.0) {
				glow += glow_color * glow_intensity * sampled.a;
			}
		}
	}

	// Moyenne pour lisser le glow
	glow /= 121.0; // 11x11 échantillons

	// Combine la texture de base avec le glow
	COLOR = base_texture + glow;
}
