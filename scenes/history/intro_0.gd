extends Node2D

@onready var player = $Player
var scene = "res://scenes/history/intro.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect2.visible = true
	player.move = false
	Stats.time = "night"
	$Fire.play("fire")

func _on_crash_finished() -> void:
	$whisper.play()
	$ColorRect2.visible = false
	await get_tree().create_timer(1.0).timeout
	mostrar_acto(Acto)
#TEXTO:
@export var TextScene: PackedScene
var Acto = 1

var actos = {
	1: { "textos": ["intro_0_txt1_d1", "intro_0_txt1_d2",], "personaje": "PLAYER", "emocion": "NORMAL" },
	2: { "textos": ["intro_0_txt1_d3"], "personaje": "HAVANY", "emocion": "NORMAL" },
	3: { "textos": ["intro_0_txt1_d4"], "personaje": "PLAYER", "emocion": "NORMAL" },
	4: { "textos": ["intro_0_txt1_d5"], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["intro_0_txt1_d6", "intro_0_txt1_d7"], "personaje": "PLAYER", "emocion": "NORMAL" },
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
		Acto = acto_numero + 1
	else:
		print("EMPIEZA EL JUEGO")
		player.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene)
