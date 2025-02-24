extends Control

var scene = "res://scenes/menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	$ButtonRestart.visible = true

func _on_button_restart_pressed() -> void:
	#efecto
	get_tree().change_scene_to_file(scene)
