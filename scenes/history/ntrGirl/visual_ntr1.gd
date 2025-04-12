extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."

func _ready() -> void:
	if Stats.visualNovel == "ntrvisual1":
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", "NTR1", "ntr1_txt")
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos and Acto != 9 and Acto !=19 and Acto !=28 and Acto !=37 and Acto !=43 and Acto !=49 and Acto != 54 and Acto !=61 and Acto !=67:
		await get_tree().create_timer(0.5).timeout
		
		if acto_numero == 10:
			MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_DOS"
		
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
	elif acto_numero == 9 or acto_numero == 19:
		Acto = acto_numero + 1
		mostrar_acto(Acto, actos)
	elif acto_numero == 28:
		audio_player.stream = load("res://sound/sounds/levantar_playera.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		mostrar_acto(Acto, actos)
	elif acto_numero == 37:
		audio_player.stream = load("res://sound/sounds/estrujar.ogg")
		audio_player.play()
		Acto = acto_numero + 1
		mostrar_acto(Acto, actos)
	elif acto_numero == 43 or acto_numero == 54 or acto_numero == 61 or acto_numero == 67:
		audio_player.stream = load("res://sound/sounds/estrujar2.ogg")
		audio_player.play()
		Acto = acto_numero + 1
		mostrar_acto(Acto, actos)
	elif acto_numero == 49:
		audio_player.stream = load("res://sound/sounds/estrujar.ogg")
		audio_player.play()
		Acto = acto_numero + 1
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
			Stats.MALO += 20
			get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
