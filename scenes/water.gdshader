shader_type canvas_item;

// Parámetros ajustables desde el inspector
uniform vec4 water_color : source_color = vec4(0.0, 0.5, 1.0, 0.5); // Color del agua (con transparencia)
uniform float wave_speed : hint_range(0.1, 5.0) = 1.0; // Velocidad de las ondas
uniform float wave_amplitude : hint_range(0.0, 1.0) = 0.1; // Amplitud de las ondas
uniform float wave_frequency : hint_range(0.1, 10.0) = 5.0; // Frecuencia de las ondas
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0; // Escala del ruido
uniform float time_scale : hint_range(0.1, 5.0) = 1.0; // Escala del tiempo

// Función de ruido simple
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Función para generar ondas
vec2 wave(vec2 uv, float time) {
    vec2 wave_uv = uv;
    wave_uv.x += sin(uv.y * wave_frequency + time * wave_speed) * wave_amplitude;
    wave_uv.y += cos(uv.x * wave_frequency + time * wave_speed) * wave_amplitude;
    return wave_uv;
}

void fragment() {
    // Obtener las coordenadas UV
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;

    // Aplicar el efecto de onda
    float time = TIME * time_scale;
    vec2 wave_uv = wave(uv, time);

    // Generar un efecto de ruido para simular textura del agua
    float noise = rand(wave_uv * noise_scale);

    // Mezclar el color del agua con el ruido
    vec4 final_color = mix(water_color, vec4(water_color.rgb, 0.8), noise);

    // Aplicar transparencia
    final_color.a *= water_color.a;

    // Asignar el color final al fragmento
    COLOR = final_color;
}