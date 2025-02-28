extends Node2D
@onready var mainScene: Node2D = $".."
@onready var player = $"../Player"
var visualNovelScene = "res://scenes/visualnovel.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainScene.No_acept.connect(no_acept_scene)


func no_acept_scene():
	$"../Player".move = false
	$Bozz.visible = true
	$Bozz.play("walk")
	player.set_shake(true)
	#SONIDO
	var tween = get_tree().create_tween()
	tween.tween_property($Bozz, "position:x", $Bozz.position.x - 200, 4)
	await get_tree().create_timer(3.8).timeout
	player.set_shake(false)
	Stats.visualNovel = "final1"
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(visualNovelScene)
