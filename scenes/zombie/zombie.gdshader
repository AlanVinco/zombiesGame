shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform vec4 new_color : source_color;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV); // Obtener color del sprite
    float diff = distance(tex_color.rgb, target_color.rgb); // Comparar con el color objetivo

    if (diff < 0.1) { // Si el color es similar al objetivo
        tex_color.rgb = new_color.rgb; // Reemplázalo por el nuevo color
    }
    
    COLOR = tex_color; // Aplica el nuevo color
}
