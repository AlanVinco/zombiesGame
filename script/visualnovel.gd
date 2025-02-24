extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
@onready var canvasImage =  $TextureRect

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)

# Exporta un Array de Dictionary para definir cada acto
@export var actosImg := [
	{
		"imagen": "res://art/cutscenes/market/escena1.png",
		"sonido": "res://audio/acto1.ogg",
		"efecto": null  # Puede ser la ruta a una escena de efecto o null si no hay efecto
	},
	{
		"imagen": "res://art/cutscenes/market/escena2.png",
		"sonido": "res://audio/acto2.ogg",
		"efecto": "res://effects/efecto1.tscn"
	},
	{
		"imagen": "res://art/cutscenes/market/escena3.png",
		"sonido": null,  # Sin sonido para este acto
		"efecto": null
	}
]

var indice_acto: int = 0  # Acto actual

@onready var btnSiguiente = $CanvasLayer2/ButtonNext
@onready var btnAnterior = $CanvasLayer2/ButtonBack
@onready var audio_player = $AudioStreamPlayer

func _ready() -> void:
	Stats.time = "day"
	mostrar_acto(Acto)

#TEXTO
@export var TextScene: PackedScene
var Acto = 1

var actos = {
	2: { "textos": ["intro_3_txt1_d1", "intro_3_txt1_d2",], 
	"image":"res://art/cutscenes/market/v1/1.png", "personaje": "", "emocion": "NORMAL" },
	3: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"],
	"image":"res://art/cutscenes/market/escena1.png", "personaje": "VENDEDORVISUAL", "emocion": "NORMAL" },
	4: { "textos": ["intro_3_txt3_d1", "intro_3_txt3_d2", "intro_3_txt3_d3", "intro_3_txt3_d4",
	"intro_3_txt3_d5"],"image":"res://art/cutscenes/market/v1/1.png", "personaje": "", "emocion": "NORMAL" },
}
func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
	elif acto_numero == 1:
		$AudioStreamPlayer.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		$AudioStreamPlayer.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto)
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto)
