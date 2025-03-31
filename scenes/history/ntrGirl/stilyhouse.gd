extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "STILYHOUSE"
var sceneCodeTxt = "stily_house_text"
var visualNovelName = "STILYHOUSE"

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
			audio_player.stream = load("res://sound/sounds/door_open_close.mp3")
			audio_player.play()
		if acto_numero == 8:
			audio_player.stream = load("res://sound/sounds/sillon.ogg")
			audio_player.play()
		if acto_numero == 14:
			audio_player.stream = load("res://sound/sounds/DUDA.ogg")
			audio_player.play()
		if acto_numero == 18:
			audio_player.stream = load("res://sound/sounds/SORPRENDIDO.ogg")
			audio_player.play()
			
		if acto_numero == 22:
			audio_player.stream = load("res://sound/sounds/NONO.ogg")
			audio_player.play()
		if acto_numero == 29:
			audio_player.stream = load("res://sound/sounds/door_open_close.mp3")
			audio_player.play()
		if acto_numero == 31:
			audio_player.stream = load("res://sound/sounds/door_open_close.mp3")
			audio_player.play()
		if acto_numero == 45:
			audio_player.stream = load("res://sound/sounds/bragueta_sound.mp3")
			audio_player.play()
			
		if acto_numero == 56:
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("stily_house1")
			$"../../GemidoLeve".stream = load("res://sound/sounds/NEWSOUNDS/LICK.ogg")
			$"../../GemidoLeve".play()
			
		if acto_numero == 64:
			$"../../Animation".play("stily_house2")
			$"../../GemidoLeve".stream = load("res://sound/sounds/NEWSOUNDS/FELLATIOREMAKE.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 71:
			$"../../GemidoLeve".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			audio_player.stream = load("res://sound/sounds/NEWSOUNDS/CUMMOUTHREMAKE.ogg")
			audio_player.play()
			$"../..".shake_camera(3.0, 4.0)
			
		if acto_numero == 82:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../.."._set_random_speed()
			$"../../Animation".play("stily_house3")
			#$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDO_LEVE1.ogg")
			$"../../GemidoLeve".stop()
		if acto_numero == 89:
			$"../..".activate_moan = false
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/NEWSOUNDS/CUMREMAKE1.ogg")
			audio_player.play()
			$"../../sonido2".stream = load("res://sound/sounds/venirseMujer1.mp3")
			$"../../sonido2".play()
			$"../..".shake_camera(3.5, 4.0)
			$"../../Animation".speed_scale = 1
		if acto_numero == 91:
			$"../..".activate_moan = true
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../.."._set_random_speed()
			$"../../Animation".play("stily_house4")
		if acto_numero == 96:
			$"../../Animation".play("stily_house5")
		if acto_numero == 102:
			$"../../Animation".play("stily_house6")
		if acto_numero == 115:
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
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	#elif acto_numero == 9 or acto_numero == 19:
		#Acto = acto_numero + 1
		#mostrar_acto(Acto, actos)
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
	
	if $"../../Animation".animation == "stily_house3" or $"../../Animation".animation == "stily_house4" or $"../../Animation".animation == "stily_house5":
		if $"../../Animation".frame == 2:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			#random_music(gemido_paths, $"../../gemidorandom")
			$"../..".shake_camera(0.1, 2.0)
	if $"../../Animation".animation == "stily_house6":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			#random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			#random_music(gemido_paths, $"../../gemidorandom")
			$"../..".shake_camera(0.1, 2.0)
