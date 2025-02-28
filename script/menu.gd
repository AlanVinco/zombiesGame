extends Control

var sceneStart = "res://scenes/history/intro_0.tscn"
var sceneLoad = "res://scenes/maps/house.tscn"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Enter"):
		var tween = get_tree().create_tween()
		tween.tween_property($LabelStart, "visible", true, 0.1)
		tween.tween_property($LabelStart, "visible", false, 0.1)
		tween.tween_property($LabelStart, "visible", true, 0.1)
		tween.tween_property($LabelStart, "visible", false, 0.1)
		tween.tween_property($LabelStart, "visible", true, 0.1)
		tween.tween_property($LabelStart, "visible", false, 0.1)
		await get_tree().create_timer(1.0).timeout
		$GridContainer.visible = true
		$LabelStart.visible = false
		$TimerShowStart.stop()

func _on_timer_show_start_timeout() -> void:
	$LabelStart.visible = !$LabelStart.visible

func _on_button_nueva_p_pressed() -> void:
	await DecisionManager.borrar_progreso()
	Stats.time = "night"
	get_tree().change_scene_to_file(sceneStart)

func _on_button_cargar_p_pressed() -> void:
	await DecisionManager.cargar_progreso()
	get_tree().change_scene_to_file(sceneLoad)
