extends Node

@export var player_position_house_hall:Vector2 = Vector2(-115, 204)
@export var player_position_house_room:Vector2 = Vector2()
@export var player_position_city:Vector2 = Vector2(342, -18)
@export var player_position_forest:Vector2 = Vector2()
@export var player_position_gym:Vector2 = Vector2(114, 169)
@export var player_position_market:Vector2 = Vector2(24, 78)
@export var player_position_office:Vector2 = Vector2(-1, 70)
@export var player_position_bar:Vector2 = Vector2(14, 102)

@onready var canvas = $CanvasModulate

# Función para cambiar el color del ambiente según la hora
func update_time_visuals():
	match Stats.time:
		"night":
			canvas.color = Color("#54469f")
		"afternoon":
			canvas.color = Color("#e27c20")
		_:
			canvas.color = Color("#ffffff")

# Escucha cambios en el tiempo cada vez que se actualiza
func _process(delta):
	update_time_visuals()

func transition():
	$CanvasLayer.visible = true
	$AnimationPlayer.play("black_transition")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$CanvasLayer.visible = false

func nex_day_animation():
	$CanvasLayer.visible = true
	$CanvasLayer/Label.visible = true
	$CanvasLayer/Label.text = str("Day ", Stats.day)
	$CanvasLayer/BlackRect.visible = true
	$DaySound.play()

func _on_day_sound_finished() -> void:
	$CanvasLayer/ColorRect.visible = true
	$CanvasLayer.visible = false
	$CanvasLayer/Label.visible = false
	$CanvasLayer/BlackRect.visible = false
