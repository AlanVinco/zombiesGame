extends Node2D

@onready var player = $Player
@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/history/intro3.tscn"

var actos = {
	1: { "textos": ["intro_3_txt1_d1", "intro_3_txt1_d2", "intro_3_txt1_d3", "intro_3_txt1_d4",
	"intro_3_txt1_d5", "intro_3_txt1_d6"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	2: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"], "personaje": "PLAYER", "emocion": "NORMAL" },
	3: { "textos": ["intro_3_txt3_d1", "intro_3_txt3_d2", "intro_3_txt3_d3", "intro_3_txt3_d4",
	"intro_3_txt3_d5"], "personaje": "HAVANY", "emocion": "NORMAL" },
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.move = false
	await get_tree().create_timer(2.0).timeout
	mostrar_acto(Acto)

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
		Acto = acto_numero + 1
	else:
		print("EMPIEZA EL JUEGO")
		player.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)
