extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ratzwel.is_scene = true
	$Ratzwel.move_manually = true
	$Ratzwel.move_to = Vector2(14, 102)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Ratzwel":
		$Ratzwel.move_to = Vector2(0, 0)
		$Ratzwel.move_manually = true
