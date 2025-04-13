extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "BARTOILET"
var sceneCodeTxt = "bar_visual_end_txt"
var visualNovelName = "BARTOILET"

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
		if acto_numero == 1:
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("bar_toilet_1")
			$"../.."._set_random_speed()
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDNO_SUAVE3.ogg")
			$"../../GemidoLeve".play()
			
		if acto_numero == 8:
			$"../../GemidoLeve".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../../sonido2".stream = load("res://sound/sounds/venirseMujer1.mp3")
			$"../../sonido2".play()
			audio_player.stream = load("res://sound/sounds/SX/squirt.mp3")
			audio_player.volume_db = 20.0
			audio_player.play()
			$"../..".shake_camera(2.0, 4.0)
			
		if acto_numero == 13:
			audio_player.volume_db = 3.0
			audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			audio_player.play()

		if acto_numero == 15:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("bar_toilet_2")
			
		if acto_numero == 22:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../..".shake_camera(3.5, 4.0)
			$"../../malecum".stream = load("res://sound/sounds/NEWSOUNDS/MALE_CUM_RANDOM1.ogg")
			$"../../malecum".play()
			audio_player.stream = load("res://sound/sounds/cumsound1.mp3")
			audio_player.play()
		
		if acto_numero == 24 or acto_numero == 37:
			audio_player.stream = load("res://sound/sounds/TOCAR_PUERTA.ogg")
			audio_player.play()
			
		if acto_numero == 26:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("bar_toilet_3")
			
		if acto_numero == 36:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../..".shake_camera(3.0, 4.0)
			$"../../malecum".stream = load("res://sound/sounds/NEWSOUNDS/MALE_CUM_RANDOM2.ogg")
			$"../../malecum".play()
			audio_player.stream = load("res://sound/sounds/SX/CUMSOUND1.mp3")
			audio_player.play()
			
		if acto_numero == 40:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("bar_toilet_4")
			
		if acto_numero == 49:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../..".shake_camera(7, 5.0)
			$"../../malecum".stream = load("res://sound/sounds/NEWSOUNDS/MALE_CUM_RANDOM4.ogg")
			$"../../malecum".play()
			audio_player.stream = load("res://sound/sounds/NEWSOUNDS/CLIMAX2.ogg")
			audio_player.play()
			
		if acto_numero == 57:
			$"../../GemidoLeve".stream = load("res://sound/sounds/RESPIRACION_BAÑO.ogg")
			$"../../GemidoLeve".play()
			$"../../GemidoLeve2".stream = load("res://sound/sounds/VOCESBAÑO.ogg")
			$"../../GemidoLeve2".play()
			
		if acto_numero == 64:
			$"../../GemidoLeve2".stop()
			$"../../GemidoLeve".stream = load("res://sound/sounds/NEWSOUNDS/RESPIRACION_TEMBLOROSA.ogg")
			$"../../GemidoLeve".play()
			audio_player.stream = load("res://sound/sounds/PUERTA_RECHINA.mp3")
			audio_player.play()
			
		if acto_numero == 70:
			$"../../GemidoLeve".stream = load("res://sound/sounds/PS1.ogg")
			$"../../GemidoLeve".play()
			$Risa1.play()
		if acto_numero == 72:
			$"../../GemidoLeve2".stream = load("res://sound/sounds/PS2.ogg")
			$"../../GemidoLeve2".play()
			$Risa2.play()
			
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
		MusicManager.start_loop_for("EXTASIS_THEME")
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
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
			Stats.HUSBAND-=20
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
	
	if $"../../Animation".animation == "bar_toilet_2" or $"../../Animation".animation == "bar_toilet_3":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
	if $"../../Animation".animation == "bar_toilet_4":
		if $"../../Animation".frame == 2:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			$"../..".shake_camera(0.1, 2.0)
	if $"../../Animation".animation == "bar_toilet_1":
		if $"../../Animation".frame == 4:
			random_music(finger_paths, $"../../bed")
			random_music(splash_paths, $"../../splash")
			
