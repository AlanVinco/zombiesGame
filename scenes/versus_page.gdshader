shader_type canvas_item;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    float scanline = sin(uv.y * 50.0 + TIME * 3.0) * 0.1;
    vec4 color = texture(TEXTURE, UV);
    color.rgb += scanline;
    COLOR = color;
}
