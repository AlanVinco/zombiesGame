extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../TextureRect"
@onready var audio_player = $"../AudioStreamPlayer"
@onready var visualNovelNode = $".."

func _ready() -> void:
	if Stats.visualNovel == "market1":
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)
		

var Acto = 1

var actos = {
	2: { "textos": ["intro_3_txt1_d1", "intro_3_txt1_d2",], 
	"image":"res://art/cutscenes/market/v1/1.png", "personaje": "", "emocion": "NORMAL" },
	3: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"],
	"image":"res://art/cutscenes/market/escena1.png", "personaje": "VENDEDORVISUAL", "emocion": "NORMAL" },
	4: { "textos": ["intro_3_txt3_d1", "intro_3_txt3_d2", "intro_3_txt3_d3", "intro_3_txt3_d4",
	"intro_3_txt3_d5"],"image":"res://art/cutscenes/market/v1/1.png", "personaje": "", "emocion": "NORMAL" },
}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
	elif acto_numero == 1:
		audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	else:
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
