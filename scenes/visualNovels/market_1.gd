extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../TextureRect"
@onready var audio_player = $"../AudioStreamPlayer"
@onready var visualNovelNode = $".."

func _ready() -> void:
	print(actos)
	if Stats.visualNovel == "market1":
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", "market1", "vnmkt1_txt")
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)
		

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos and Acto != 17 and Acto != 37:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
	elif acto_numero == 0:
		audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		
	elif acto_numero == 17:
		$"../TextureRect".visible = false
		audio_player.stream = load("res://sound/sounds/bigKiss.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		$kisses.play()
		
	elif acto_numero == 37:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/clothes-frotar.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	else:
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
