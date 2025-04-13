extends Node

var paused = false

@onready var panel = $CanvasLayer/Panel
@onready var exit_button = $CanvasLayer/Panel/ButtonExit
@onready var exit_modal = $CanvasLayer/ConfirmationDialog
@onready var music_slider = $CanvasLayer/Panel/HBoxContainer/HSlider
@onready var sound_slider = $CanvasLayer/Panel/HBoxContainer2/HSlider
var tween = create_tween()
var is_open = false

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	exit_modal.confirmed.connect(_on_exit_confirmed)
	exit_modal.canceled.connect(_on_exit_cancelled)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sound_slider.value_changed.connect(_on_sound_volume_changed)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		paused = get_tree().paused
		if paused:
			$CanvasLayer.visible = true
		else:
			$CanvasLayer.visible = false
			
func _on_exit_pressed():
	#exit_modal.visible = true
	exit_modal.dialog_text = "txt_exit_game"
	exit_modal.popup_centered()

func _on_exit_confirmed():
	get_tree().quit()

func _on_exit_cancelled():
	exit_modal.hide()

func _on_music_volume_changed(value):
	# Ajusta volumen global de música
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100))

func _on_sound_volume_changed(value):
	# Ajusta volumen global de sonidos
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value / 100))

#func toggle_menu():
	#is_open = not is_open
	#set_process_input(is_open)
	#if is_open:
		#$CanvasLayer.visible = true
		#panel.scale = Vector2(0.5, 0.5)
		#panel.modulate.a = 0
		#tween.tween_property(panel, "scale", Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
		#tween.tween_property(panel, "modulate:a", 1.0, 0.3)
		#get_tree().paused = true
	#else:
		#tween.tween_property(panel, "modulate:a", 0.0, 0.2)
		#tween.tween_property(panel, "scale", Vector2(0.5, 0.5), 0.2)
		#await tween.finished
		#$CanvasLayer.visible = false
		#get_tree().paused = false
