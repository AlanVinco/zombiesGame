extends Node

@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
signal on_all_texts_displayed
var actos = {}

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#print("Datos filtrados:", actos)
	original_camera_position = camera.position  # Guarda la posición inicial
	Stats.time = "day"

#TEXTO
@export var TextScene: PackedScene

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	emit_signal("on_all_texts_displayed")

func cargar_csv(ruta, escena_filtrada, keyWord):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if not file:
		print("❌ Error al abrir el archivo CSV")
		return

	var contenido = file.get_as_text().strip_edges()
	file.close()

	var lineas = contenido.split("\n", false)
	if lineas.size() <= 1:
		print("⚠ Archivo vacío o con solo encabezados")
		return

	var encabezados = []
	var data = []
	
	for i in range(lineas.size()):
		var columnas = parse_csv_line(lineas[i])  # 🔹 Nueva función para procesar CSV correctamente

		if i == 0:
			encabezados = columnas
			continue  # Saltamos la primera línea (encabezados)

		if columnas.size() != encabezados.size():
			#print("⚠ Error en la línea", i, "->", columnas)
			continue

		var fila = {}
		for j in range(encabezados.size()):
			fila[encabezados[j].strip_edges()] = columnas[j].strip_edges() if j < columnas.size() else ""

		if fila.get("escena", "") == escena_filtrada:
			data.append(fila)

	if data.is_empty():
		print("⚠ No se encontraron datos para la escena:", escena_filtrada)
		return

	var index = 1  # Contador para los actos

	for i in range(data.size()):
		var fila = data[i]
		var clave_texto = keyWord + str(i + 1)

		var personaje = fila.get("personaje", "").strip_edges()
		var emocion = fila.get("emocion", "NORMAL").strip_edges()
		var image = fila.get("image", "").strip_edges()

		print("✅ Procesado:", clave_texto, "Personaje:", personaje, "Emoción:", emocion, "Imagen:", image)

		actos[index] = {
			"textos": [clave_texto],
			"image": image,
			"personaje": personaje,
			"emocion": emocion
		}

		index += 1

func parse_csv_line(line):
	var result = []
	var current = ""
	var in_quotes = false

	for i in range(line.length()):
		var char = line[i]

		if char == "\"" and (i == 0 or line[i - 1] != "\\"):  
			in_quotes = !in_quotes  # Cambiar estado de comillas
		elif char == "," and !in_quotes:
			result.append(current.strip_edges())
			current = ""
		else:
			current += char

	if current != "":
		result.append(current.strip_edges())

	return result


func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalTransitions.transition()
	GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
	GlobalTransitions.player_position_city = Vector2(342, -18)
	await get_tree().create_timer(0.5).timeout
	Stats.time = "night"
	Stats.MALO += 20
	get_tree().change_scene_to_file("res://scenes/maps/house.tscn")

# Nueva variable para almacenar la posición original de la cámara
var original_camera_position: Vector2

# Nueva función para sacudir la cámara con duración e intensidad configurables
func shake_camera(duration: float = 0.5, intensity: float = 10.0):
	var original_position = camera.position  # Se obtiene la posición actual de la cámara
	var tween = get_tree().create_tween()
	
	for i in range(int(duration * 60)):  # Aproximadamente 60 FPS
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(camera, "position", original_position + random_offset, 0.02)

	tween.tween_property(camera, "position", original_position, 0.1)  # Vuelve a la posición original
#SPEED
@onready var timer = $AnimationSpeed # Asegúrate de tener un Timer en la escena y asignarlo
@onready var sprite = $Animation
# Rango de velocidad de la animación
@export var min_speed: float = 0.8
@export var max_speed: float = 2.0

# Rango de tiempo entre cambios de velocidad
@export var min_time: float = 3.0
@export var max_time: float = 6.0
@export var activate_moan = false

var current_sound = null  # Variable para almacenar el sonido actual

func _set_random_speed():
	var new_speed = randf_range(min_speed, max_speed)
	print(sprite)
	sprite.speed_scale = new_speed  # Modifica la velocidad de la animación

	var new_time = randf_range(min_time, max_time)
	timer.start(new_time)  # Reinicia el timer con un tiempo aleatorio

	var new_sound = null  # Para determinar qué sonido debe reproducirse

	if activate_moan and new_speed <= 2 and new_speed > 1:
		new_sound = "res://sound/sounds/GEMIDO/GEMIDO_FUERTE1.ogg"
	elif activate_moan and new_speed <= 1 and new_speed > 0.5:
		new_sound = "res://sound/sounds/gime_leve1.ogg"
	elif activate_moan and new_speed <= 0.5 and new_speed >= 0.8:
		new_sound = "res://sound/sounds/GEMIDO/GEMIDNO_SUAVE3.ogg"

	# Si hay un nuevo sonido y no es el mismo que se está reproduciendo
	if new_sound and (new_sound != current_sound or !$moanRandom.playing):
		current_sound = new_sound  # Guardamos el sonido actual
		$moanRandom.stream = load(new_sound)
		$moanRandom.play()

func _on_timer_timeout():
	_set_random_speed()  # Cambia la velocidad cuando el timer termine


func _on_button_exit_pressed() -> void:
	$AudioStreamPlayer.stream = load("res://sound/sounds/THE_END_SOUND.mp3")
	$AudioStreamPlayer.play()
	$"THE END/ButtonExit".visible = false
	DecisionManager.guardar_progreso()
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
