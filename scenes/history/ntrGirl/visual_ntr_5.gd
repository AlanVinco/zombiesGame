extends Node

var nextScene = "res://scenes/visualNovels/ntr_3_house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "NTR5VISUAL"
var sceneCodeTxt = "ntr5_visual_txt"
var visualNovelName = "NTR5VISUAL"

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
			$RisasVillanos.play()
			#audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			#audio_player.play()
		if acto_numero == 4:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("ntr5_scene1")
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDO_FUERTE3.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 6:
			$"../../Animation".play("ntr5_scene2")
		if acto_numero == 7:
			$"../../Animation".play("ntr5_scene3")
		if acto_numero == 8:
			$"../../Animation".play("ntr5_scene4")
		if acto_numero == 9:
			$"../../Animation".play("ntr5_scene5")
		if acto_numero == 10:
			$"../../Animation".play("ntr5_scene6")
		if acto_numero == 11:
			$"../../Animation".play("ntr_5_scene7")
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		#audio_player.stream = load("res://sound/sounds/convert_ntr_sound.mp3")
		#audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	#elif acto_numero == 9 or acto_numero == 19:
		#Acto = acto_numero + 1
		#mostrar_acto(Acto, actos)
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
	
	if $"../../Animation".animation == "ntr5_scene1" or  $"../../Animation".animation == "ntr5_scene3":
		print("si entro")
		if $"../../Animation".frame == 2:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr5_scene4" or $"../../Animation".animation == "ntr5_scene5" or $"../../Animation".animation == "ntr5_scene6":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr5_scene2" or $"../../Animation".animation == "ntr_5_scene7":
		if $"../../Animation".frame == 4:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
