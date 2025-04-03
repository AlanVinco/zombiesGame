shader_type canvas_item;
uniform float speed : hint_range(0.1, 5.0) = 1.5;

void fragment() {
    float pulse = (sin(TIME * speed) + 1.0) * 0.5; // Oscila entre 0 y 1
    float dist = length(UV - vec2(0.5));
    float intensity = smoothstep(0.5, 0.0, dist) * pulse;

    COLOR = vec4(0.2, 0.5, 1.0, intensity); // Color azul mágico
}
