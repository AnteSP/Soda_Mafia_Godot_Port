shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;
uniform float distortion_strength = 0.2;
uniform float zoom = 0.9; // tweak this

void fragment() {
    vec2 uv = SCREEN_UV;

    // Zoom toward center
    vec2 centered = uv - 0.5;
    centered *= zoom;
    uv = centered + 0.5;

    // Now apply distortion
    vec2 d = uv * 2.0 - 1.0;
    float r = length(d);

    d *= 1.0 + distortion_strength * r * r;

    vec2 distorted_uv = d * 0.5 + 0.5;

    COLOR = texture(screen_tex, distorted_uv);
}