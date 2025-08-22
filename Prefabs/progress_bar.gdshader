shader_type canvas_item;

uniform float progress : hint_range(0, 1) = 0.0;

void fragment() {
    // Smooth the edges a bit
    float edge = 0.01;
    float alpha = smoothstep(progress, progress + edge, UV.x);
    COLOR = texture(TEXTURE, UV);
	COLOR.g = 0.47;
	COLOR.b = 0.15;
    COLOR.a *= (0.5 - alpha);
}