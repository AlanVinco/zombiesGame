extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "LOVE3"
var sceneCodeTxt = "love3_txt"
var visualNovelName = "LOVE3"

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		
		if acto_numero == 2 or acto_numero == 3 or acto_numero == 4 or acto_numero == 9 or acto_numero == 10 or acto_numero == 11 or acto_numero == 27:
			$"../..".shake_camera(1, 9.0)
		
		if acto_numero == 1:
			MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
			MusicManager.start_loop_for("VISUAL_TRES")
			$"../..".shake_camera(2, 12.0)
			$"../../sonido2".stream = load("res://sound/sounds/door_open_close.mp3")
			$"../../sonido2".play()
			$VenirseMujer1.play()
			audio_player.stream = load("res://sound/sounds/SX/squirt.mp3")
			audio_player.play()
			
		if acto_numero == 12:
			MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
			MusicManager.start_loop_for("EXTASIS_THEME")
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("love_scene5")
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDO_FUERTE1.ogg")
			$"../../GemidoLeve".play()
			
		if acto_numero == 27:
			audio_player.stream = load("res://sound/sounds/TOCAR_PUERTA.ogg")
			audio_player.play()
			
		if acto_numero == 40:
			$"../..".shake_camera(4, 13.0)
			$"../../Animation".stop()
			$"../../GemidoLeve".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/grito_climax1.ogg")
			audio_player.play()
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/RESPIRACION_MUJER_FINAL.ogg")
			$"../../GemidoLeve".play()
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
		MusicManager.start_loop_for("VISUAL_TRES")
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)

	else:
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			audio_player.stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
			audio_player.play()
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
		"res://sound/sounds/SX/SLAP1.ogg",
		"res://sound/sounds/SX/SLAP2.ogg",
		"res://sound/sounds/SX/SLAP3.ogg",
		"res://sound/sounds/SX/SLAP4.ogg"
	]
	var bed_paths = [
		"res://sound/sounds/SX/BED1.ogg",
		"res://sound/sounds/SX/BED2.ogg",
		"res://sound/sounds/SX/BED3.ogg",
		"res://sound/sounds/SX/BED4.ogg",
	]
	var slime_paths = [
		"res://sound/sounds/SX/SLIME1.ogg",
		"res://sound/sounds/SX/SLIME2.ogg",
		"res://sound/sounds/SX/SLIME3.ogg",
		"res://sound/sounds/SX/SLIME4.ogg",
		"res://sound/sounds/SX/SLIME5.ogg",
		"res://sound/sounds/SX/SLIME6.ogg",
		"res://sound/sounds/SX/SLIME7.ogg",
	]
	
	if $"../../Animation".animation == "love_scene5":
		if $"../../Animation".frame == 0:
			random_music(slap_paths, $"../../slap")
			random_music(slime_paths, $"../../slime")
			$"../..".shake_camera(0.1, 2.0)
