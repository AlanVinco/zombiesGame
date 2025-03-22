extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "LOVE1"
var sceneCodeTxt = "love_txt"
var visualNovelName = "loveSex"

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 59

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero == 61 and Stats.MALO <40:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		Stats.HUSBAND += 20
		get_tree().change_scene_to_file(nextScene)
	elif acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		if acto_numero == 1 or acto_numero == 8:
			audio_player.stream = load("res://sound/sounds/levantar_playera.mp3")
			audio_player.play()
		if acto_numero == 23:
			audio_player.stream = load("res://sound/sounds/bragueta_sound.mp3")
			audio_player.play()
		if acto_numero == 27:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("love_scene1")
			$HFellaKyo30.play()
		if acto_numero == 31:
			$"../../Animation".play("love_scene2")
			$HFellaKyo30.stop()
			$HFellaUrgency.play()
		if acto_numero == 36:
			$"../../Animation".stop()
			$HFellaUrgency.stop()
			audio_player.stream = load("res://sound/sounds/SX/CUMSOUND1.mp3")
			audio_player.play()
		if acto_numero == 39:
			###OCULTAAAAAAAAAR####
			audio_player.stream = load("res://sound/sounds/bed.mp3")
			audio_player.play()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
		if acto_numero == 45:
			audio_player.stream = load("res://sound/sounds/condon_pequeño.ogg")
			audio_player.play()
		if acto_numero == 48:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("love_scene3")
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/player_breath_sex.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 51:
			$"../../GemidoLeve".stop()
			$"../../Animation".stop()
			$"../../sonido2".stream = load("res://sound/sounds/SX/CUMSOUND2.mp3")
			$"../../sonido2".play()
			audio_player.stream = load("res://sound/sounds/GEMIDO/player_cum.ogg")
			audio_player.play()
		if acto_numero == 53:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../sonido2".stream = load("res://sound/sounds/kiss_boca1.mp3")
			$"../../sonido2".play()
		if acto_numero == 63:
			$"../../GemidoLeve".stream = load("res://sound/sounds/sleep_sound.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 71:
			audio_player.stream = load("res://sound/sounds/SX/BED1.ogg")
			audio_player.play()
		if acto_numero == 73:
			$"../../GemidoLeve".stop()
			audio_player.stream = load("res://sound/sounds/dild_sound.mp3")
			audio_player.play()
		
		if acto_numero == 75:
			###OCULTAAAAAAAAAR####
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDNO_SUAVE3.ogg")
			$"../../GemidoLeve".play()
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Animation".play("love_scene4")
			$"../../Effect".visible = true
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		#audio_player.stream = load("res://sound/sounds/convert_ntr_sound.mp3")
		#audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(0.5).timeout
		mostrar_acto(Acto, actos)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file("res://scenes/history/love_1_house.tscn")

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
	
	if $"../../Animation".animation == "love_scene3":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "love_scene4":
		if $"../../Animation".frame == 0 or $"../../Animation".frame == 3:
			random_music(slime_paths, $"../../slime")
