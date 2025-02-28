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
		if has_node("../Botiquin"):
			tween.parallel().tween_property($"../Botiquin", "position:y", $"../Botiquin".position.y + 50, 3)
		if has_node("../Comida"):
			tween.parallel().tween_property($"../Comida", "position:y", $"../Comida".position.y + 50, 3)
		
		# Mueve los Labels hacia abajo
		tween.parallel().tween_property($txtWASD4, "position:y", $txtWASD4.position.y + 50, 3)
		tween.parallel().tween_property($txtWASD, "position:y", $txtWASD.position.y + 50, 3)  # Label 1
		tween.parallel().tween_property($txtWASD2, "position:y", $txtWASD2.position.y + 50, 3)  # Label 2
		tween.parallel().tween_property($txtWASD3, "position:y", $txtWASD3.position.y + 50, 3)  # Label 3
	else:
		# Mueve los nodos hacia arriba si existen
		if has_node("../Botiquin"):
			tween.parallel().tween_property($"../Botiquin", "position:y", $"../Botiquin".position.y - 50, 3)
		if has_node("../Comida"):
			tween.parallel().tween_property($"../Comida", "position:y", $"../Comida".position.y - 50, 3)
		
		# Mueve los Labels hacia arriba
		tween.parallel().tween_property($txtWASD4, "position:y", $txtWASD4.position.y - 50, 3)
		tween.parallel().tween_property($txtWASD, "position:y", $txtWASD.position.y - 50, 3)  # Label 1
		tween.parallel().tween_property($txtWASD2, "position:y", $txtWASD2.position.y - 50, 3)  # Label 2
		tween.parallel().tween_property($txtWASD3, "position:y", $txtWASD3.position.y - 50, 3)  # Label 3
