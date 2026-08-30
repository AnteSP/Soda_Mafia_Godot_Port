shader_type canvas_item;

uniform float time_speed = 2.0;      // how fast distortion moves
uniform float noise_strength = 0.01; // horizontal tearing
uniform float jitter = 1.0;          // vertical jitter amount
uniform float scanline_strength = 0.15;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;

    // VHS horizontal noise
    float noise = (fract(sin(uv.y * 800.0 + TIME * time_speed) * 43758.5453) - 0.5);
    uv.x += noise * noise_strength;

    // Vertical jitter
    uv.y += (fract(TIME * 3.0) - 0.5) * (jitter / 100.0);

    // Texture sample
    vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV + (uv - UV));

    // Scanlines
    float line = sin(uv.y * 720.0) * scanline_strength;
    col.rgb -= line;

    COLOR = col;
}
