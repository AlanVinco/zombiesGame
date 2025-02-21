shader_type canvas_item;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    // Resaltar colores brillantes (como fuego)
    float intensity = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    float glow = smoothstep(0.3, 0.8, intensity);
    
    // Agregar un brillo extra en los bordes
    vec2 offset = vec2(0.005);
    float glow_extra = texture(TEXTURE, UV + offset).a +
                       texture(TEXTURE, UV - offset).a;
    glow *= sin(TIME * 5.0) * 0.3 + 0.7;

    COLOR = tex + vec4(vec3(glow) * glow_extra * 0.5, 0.0);
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
