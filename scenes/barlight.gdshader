shader_type canvas_item;

uniform float speed = 10.0;  // Pulso más rápido
uniform vec3 light_color = vec3(1.0, 0.0, 0.0);  // Color inicial (rojo)
uniform float alpha_intensity = 0.5;  // Control de transparencia

void fragment() {
    float pulse = (sin(TIME * speed) + 1.0) * 0.5; // Oscila entre 0 y 1
    float dist = length(UV - vec2(0.5));
    float intensity = smoothstep(0.5, 0.0, dist) * pulse;
    
    COLOR = vec4(light_color * intensity, alpha_intensity * intensity); // Color dinámico con transparencia
}
