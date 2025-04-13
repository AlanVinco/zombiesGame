extends Node

var nextScene = "res://scenes/history/ntrGirl/ntr_4_house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "NTR4"
var sceneCodeTxt = "ntr4_visual_txt"
var visualNovelName = "ntrvisual4"

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		
		if acto_numero == 16 or acto_numero == 17 or acto_numero == 18  or acto_numero == 22  or acto_numero == 27  or acto_numero == 28  or acto_numero == 29 or acto_numero == 123 or acto_numero == 134:
			$"../..".shake_camera(1, 9.0)
		#if acto_numero == 24:
			#audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			#audio_player.play()
			
		if acto_numero == 1:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("ntr4_scene1")
			$FrotalPielDebil.play()
		if acto_numero == 15:
			audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			audio_player.play()
			$FrotalPielDebil.stop()
			###OCULTAAAAAAAAAR####
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			
		if acto_numero == 29:
			$"../..".activate_moan = true
			MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
			MusicManager.start_loop_for("EXTASIS_THEME")
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../.."._set_random_speed()
			
			#$"../../GemidoLeve".play()
			$"../../Animation".play("ntr4_scene2")
		if acto_numero == 40:
			$"../../Animation".play("ntr4_scene3")
			#$"../../GemidoLeve".play()
			
		if acto_numero == 57:
			$"../../malecum".stream = load("res://sound/sounds/SX/cm/cumsound_girl_corto.ogg")
			$"../../malecum".play()
			
		if acto_numero == 57 or acto_numero == 61:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			
			#PARAR
			$"../../Animation".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../GemidoLeve".stop()
			$"../..".shake_camera(3, 12.0)
			audio_player.stream = load("res://sound/sounds/SX/CUMSOUND1.mp3")
			audio_player.play()
		if acto_numero == 70:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("ntr4_scene4")
			$"../.."._set_random_speed()
			
		if acto_numero == 82:
			$"../../Animation".play("ntr4_scene5")

		if acto_numero == 93:

			$"../../Animation".play("ntr4_scene6")
		if acto_numero == 110:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
						#PARAR
			$"../..".shake_camera(3, 12.0)
			audio_player.stream = load("res://sound/sounds/SX/cm/grito_corto_cum_largo.ogg")
			audio_player.play()
			$"../../malecum".stream = load("res://sound/sounds/SX/CUMSOUND1.mp3")
			$"../../malecum".play()
			$"../../GemidoLeve".stop()
			$"../../Animation".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
		if acto_numero == 119:
			MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_CORRUPTED"
			audio_player.stream = load("res://sound/sounds/bed.mp3")
			audio_player.play()
			MusicManager.start_loop_for("HAVANY_CORRUPTED")
		if acto_numero == 128:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Animation".play("ntr4_scene7")
			$"../NTR3/Besos".play()
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
		MusicManager.start_loop_for("VISUAL_TRES")
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
			audio_player.stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
			audio_player.play()
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "night"
			Stats.MALO += 20
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
	var espejo_paths = [
		"res://sound/sounds/NEWSOUNDS/ESPEJO1.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO2.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO3.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO4.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO5.ogg",
	]
	var splash_paths = [
		"res://sound/sounds/NEWSOUNDS/SPLASH1.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH2.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH3.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH4.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH5.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH6.ogg",
	]
	
	var finger_paths = [
		"res://sound/sounds/NEWSOUNDS/FINGER1.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER2.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER3.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER4.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER5.ogg",
	]
	
	if $"../../Animation".animation == "ntr4_scene2":
		if $"../../Animation".frame == 2:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr4_scene3":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr4_scene4":
		if $"../../Animation".frame == 4:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
	if $"../../Animation".animation == "ntr4_scene5":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
	if $"../../Animation".animation == "ntr4_scene6":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
