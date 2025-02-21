shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//Agarra el color de esta textura en esta posicion
	//UV son las coordenadas XY
	vec4 _input_color = texture(TEXTURE, UV);
	COLOR = vec4(_input_color.r,0.0,0.0, _input_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
