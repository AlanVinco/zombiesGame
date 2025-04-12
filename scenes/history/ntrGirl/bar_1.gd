extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "BARVISUAL1"
var sceneCodeTxt = "bar_visual1_txt"
var visualNovelName = "BARVISUAL1"

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)
		timer.timeout.connect(_change_light_effect)
		timer.start(0.5)  # Cambia cada 0.5s

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		if acto_numero == 8:
			MusicManager.music_player["parameters/switch_to_clip"] = "BAR_DANCE"
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("bar_2_scene1")
			audio_player.stream = load("res://sound/sounds/abrir_cortinas.ogg")
			audio_player.play()
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/bar_voces.ogg")
			$"../../GemidoLeve".play()
			
		if acto_numero == 12:
			$"../../Animation".play("bar_2_scene2")

		if acto_numero == 17:
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			
		if acto_numero == 29:
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("bar_2_scene3")
			$"../../GemidoLeve2".stream = load("res://sound/sounds/GEMIDO/masturbatin1.ogg")
			$"../../GemidoLeve2".play()
			#$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDO_LEVE1.ogg")
		if acto_numero == 33:
			$"../../GemidoLeve2".stop()
			$"../..".activate_moan = false
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/GEMIDO/squirting.ogg")
			audio_player.play()
			$"../..".shake_camera(2.0, 4.0)
			$"../../Animation".speed_scale = 1
		if acto_numero == 35:
			$"../../GemidoLeve2".stream = load("res://sound/sounds/aplausos.ogg")
			$"../../GemidoLeve2".play()
		if acto_numero == 43:
			MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
			$"../../GemidoLeve2".stop()
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../.."._set_random_speed()
			$"../../Animation".play("bar_2_scene4")
		if acto_numero == 53:
			$"../..".activate_moan = false
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/NEWSOUNDS/CLIMAX_VIDEO_REMAKE.ogg")
			audio_player.play()
			$"../..".shake_camera(12, 5.0)
			$"../../Animation".speed_scale = 1
		
		
		if acto_numero == 55:
			audio_player.stream = load("res://sound/sounds/cerrar_cortinas.ogg")
			audio_player.play()
			$"../../GemidoLeve2".stream = load("res://sound/sounds/aplausos.ogg")
			$"../../GemidoLeve2".play()
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		$"../../GemidoLeve".volume_db = -20.0  # Baja el volumen a -10 dB
		$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/bar_voces1.ogg")
		$"../../GemidoLeve".play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	#elif acto_numero == 9 or acto_numero == 19:
		#Acto = acto_numero + 1
		#mostrar_acto(Acto, actos)
	else:
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "night"
			get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()


func _on_animation_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var slap_paths = [
		"res://sound/sounds/NEWSOUNDS/GOLPE1.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE2.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE3.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE4.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE5.ogg",
	]
	var bed_paths = [
		"res://sound/sounds/NEWSOUNDS/RECHINA1.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA2.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA3.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA4.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA5.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA6.ogg",
	]
	var slime_paths = [
		"res://sound/sounds/NEWSOUNDS/AGUA1.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA2.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA3.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA4.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA5.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA6.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA7.ogg",
	]
	
	if $"../../Animation".animation == "bar_2_scene4":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			#random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			#random_music(gemido_paths, $"../../gemidorandom")
			$"../..".shake_camera(0.1, 2.0)


@onready var light = $"../../PointLight2D2"  # Asegúrate de tener una luz en la escena
@onready var tween = get_tree().create_tween()
@onready var timer = $"../../FlashBar"  # Necesitas un Timer en la escena
@onready var shader_mat = light.material  # Usa el material del nodo Light2D o Sprite2D

func _change_light_effect():
	var new_color = Color(randf(), randf(), randf())  # Color RGB aleatorio
	shader_mat.set_shader_parameter("light_color", new_color)
