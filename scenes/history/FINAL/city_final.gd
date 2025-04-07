extends Node2D

@onready var message_box = $CanvasLayer/MessageBox
@onready var message_label = $CanvasLayer/MessageBox/Label
@onready var accept_button = $CanvasLayer/MessageBox/AcceptButton
@onready var decline_button = $CanvasLayer/MessageBox/DeclineButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_stily_house_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$stily_house/ButtonExit.visible = true

func _on_stily_house_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$stily_house/ButtonExit.visible = false

func _on_button_exit_pressed() -> void:
	$stily_house/ButtonExit.visible = false
	message_box.visible = true
	animate_message_box(true)

func animate_message_box(show: bool):
	var tween = create_tween()
	message_box.modulate.a = 0 if show else 1
	tween.tween_property(message_box, "modulate:a", 1 if show else 0, 0.3)
	if not show:
		await tween.finished
		message_box.visible = false


func _on_accept_button_pressed() -> void:
	message_box.visible = false
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	Stats.visualNovel = "PERDONAR"
	get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")

func _on_decline_button_pressed() -> void:
	message_box.visible = false
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	Stats.visualNovel = "OLVIDAR"
	get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")
