extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."

func _ready() -> void:
	if Stats.visualNovel == "ntrvisual2":
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", "NTR2", "ntr2_visual_txt")
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		if acto_numero == 4 or acto_numero == 9 or acto_numero == 28 or acto_numero == 34:
			audio_player.stream = load("res://sound/sounds/levantar_playera.mp3")
			audio_player.play()
		if acto_numero == 43:
			$"../../Market1/kisses".play()
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Animation".play("NTR2Lamer")
		if acto_numero == 64:
			$"../../GemidoLeve".play()
		if acto_numero == 81:
			$"../../Market1/kisses".stop()
			audio_player.stream = load("res://sound/sounds/squirt.mp3")
			$"../../sonido2".stream = load("res://sound/sounds/venirseMujer1.mp3")
			$"../../GemidoLeve".stop()
			$"../../sonido2".play()
			audio_player.play()
			$"../../Animation".play("NTR2SquirtStart")
		if acto_numero == 87:
			$"../../Market1/breath".play()
			$Gota.play()
			$"../../GemidoLeve".play()
			$"../../Animation".play("NTR2squirt")
		
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound.mp3")
		audio_player.play()
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
