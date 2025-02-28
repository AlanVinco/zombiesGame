extends Node

@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
signal on_all_texts_displayed

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)

func _ready() -> void:
	Stats.time = "day"

#TEXTO
@export var TextScene: PackedScene

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	emit_signal("on_all_texts_displayed")
