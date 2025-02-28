extends Node2D

var upDown = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	
	# Alterna la dirección del movimiento
	upDown = !upDown
	
	if upDown:
		# Mueve los nodos hacia abajo si existen
		# Mueve los Labels hacia abajo
		tween.parallel().tween_property($txtWASD, "position:y", $txtWASD.position.y + 50, 3)  # Label 1
		tween.parallel().tween_property($txtWASD2, "position:y", $txtWASD2.position.y + 50, 3)  # Label 2
	else:
		# Mueve los Labels hacia arriba
		tween.parallel().tween_property($txtWASD, "position:y", $txtWASD.position.y - 50, 3)  # Label 1
		tween.parallel().tween_property($txtWASD2, "position:y", $txtWASD2.position.y - 50, 3)  # Label 2
