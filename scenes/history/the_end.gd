extends CanvasLayer

@onready var the_end := $TextureRect

func mostrar_the_end():
	$"../AudioStreamPlayer".stream = load("res://sound/sounds/THE_END_SOUND.mp3")
	$"../AudioStreamPlayer".play()
	visible = true  # Hacemos visible el CanvasLayer

	the_end.modulate.a = 0.0         # Invisible
	the_end.scale = Vector2(0.6, 0.6)  # Un poco más pequeño

	var tween = get_tree().create_tween()

	# Aparece con fade-in y escala suave
	tween.tween_property(the_end, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(the_end, "scale", Vector2(1, 1), 1.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
