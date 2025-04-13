extends Control

@onready var animations = $Animator
@onready var camera = $Animator/Camera2D
var original_camera_position: Vector2


var sceneStart = "res://scenes/history/intro_0.tscn"
var sceneLoad = "res://scenes/maps/house.tscn"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Enter"):
		$Buttons.stream = load("res://sound/sounds/UIX/Languaje_button.mp3")
		$Buttons.play()
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
		if Stats.visualNovel == "final1" or not FileAccess.file_exists("user://decision_tree_save.json"):
			$GridContainer/ButtonCargarP.visible = false

func _on_timer_show_start_timeout() -> void:
	$LabelStart.visible = !$LabelStart.visible

func _on_button_nueva_p_pressed() -> void:
	#$Animator.stop()
	shake_camera(5.0, 15.0)
	$GridContainer.visible = false
	$Buttons.stream = load("res://sound/sounds/UIX/New_game_sound.mp3")
	$Buttons.play()
	MusicManager.music_player.stop()
	await get_tree().create_timer(2.0).timeout
	$Animator.visible = false
	await get_tree().create_timer(3.0).timeout 
	await DecisionManager.borrar_progreso()
	Stats.time = "night"
	get_tree().change_scene_to_file(sceneStart)

func _on_button_cargar_p_pressed() -> void:
	shake_camera(5.0, 15.0)
	$GridContainer.visible = false
	$Buttons.stream = load("res://sound/sounds/UIX/New_game_sound.mp3")
	$Buttons.play()
	MusicManager.music_player.stop()
	await get_tree().create_timer(2.0).timeout
	$Animator.visible = false
	await get_tree().create_timer(3.0).timeout 
	await DecisionManager.cargar_progreso()
	get_tree().change_scene_to_file(sceneLoad)
	
func _ready() -> void:
	original_camera_position = camera.position  # Guarda la posición inicial
	MusicManager.music_player["parameters/switch_to_clip"] = "MENU_THEME"
	MusicManager.music_player.play()
	MusicManager.start_loop_for("MENU_THEME")
	await get_tree().create_timer(0.2).timeout 
	$Animator.visible = true
	await get_tree().create_timer(1.75).timeout 
	$Animator.play("menu")

# Nueva función para sacudir la cámara con duración e intensidad configurables
func shake_camera(duration: float = 0.5, intensity: float = 10.0):
	var original_position = camera.position  # Se obtiene la posición actual de la cámara
	var tween = get_tree().create_tween()
	
	for i in range(int(duration * 60)):  # Aproximadamente 60 FPS
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(camera, "position", original_position + random_offset, 0.02)

	tween.tween_property(camera, "position", original_position, 0.1)  # Vuelve a la posición original
