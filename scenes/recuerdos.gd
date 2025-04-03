extends Control

@onready var grid_container = $CanvasLayer/GridContainer
@onready var texture_rect = $CanvasLayer/TextureRect
@onready var message_box = $CanvasLayer/MessageBox
@onready var message_label = $CanvasLayer/MessageBox/Label
@onready var accept_button = $CanvasLayer/MessageBox/AcceptButton
@onready var decline_button = $CanvasLayer/MessageBox/DeclineButton

@export var visual_novels = {
	1: { "sceneName": "market1", "buttonName": "MARKET1", "backgroundImage": "res://art/cutscenes/market/v1/s13.png" },
	2: { "sceneName": "final1", "buttonName": "FINAL1", "backgroundImage": "res://art/cutscenes/final1/ComfyUI_00490_.png" },
	3: { "sceneName": "ntrvisual1", "buttonName": "NTR1", "backgroundImage": "res://art/cutscenes/NTR/ntr1/S3.png" },
	4: { "sceneName": "ntrvisual2", "buttonName": "NTR2", "backgroundImage": "res://art/cutscenes/NTR/ntr2/S13.png" },
	5: { "sceneName": "ntrvisual3", "buttonName": "NTR3", "backgroundImage": "res://art/cutscenes/NTR/ntr3/S14.png" },
	6: { "sceneName": "ntrvisual4", "buttonName": "NTR4", "backgroundImage": "res://art/cutscenes/NTR/ntr4/S4.png" },
	7: { "sceneName": "NTR5VISUAL", "buttonName": "NTR5", "backgroundImage": "res://art/cutscenes/NTR/ntr5/CUM0008.png" },
	8: { "sceneName": "MISSION3", "buttonName": "MISSION3PART1", "backgroundImage": "res://art/cutscenes/MISSIONS/mission3/animations/zombie_sx0000.png" },
	9: { "sceneName": "MISSION3VISUAL2", "buttonName": "MISSION3PART2", "backgroundImage": "res://art/cutscenes/MISSIONS/mission3/S4.png" },
	10: { "sceneName": "loveSex", "buttonName": "LOVEPART1", "backgroundImage": "res://art/cutscenes/love/S10.png" },
	11: { "sceneName": "LOVE3", "buttonName": "LOVEPART2", "backgroundImage": "res://art/cutscenes/love/ANIMATIONS/love_final0002.png" },
	12: { "sceneName": "BARVISUAL1", "buttonName": "BAR1", "backgroundImage": "res://art/cutscenes/Bar/S14.png" },
	13: { "sceneName": "BARTOILET", "buttonName": "BAR2", "backgroundImage": "res://art/cutscenes/BARTOILET/S5.png" },
	14: { "sceneName": "STILYHOUSE", "buttonName": "STILYHOUSE", "backgroundImage": "res://art/cutscenes/Stily/animations/lick0000.png" },
	15: { "sceneName": "BODAFINAL", "buttonName": "ENDPART1", "backgroundImage": "res://art/cutscenes/FINAL BODA/S11.png" },
}

var unlocked_scenes = []

var selected_novel = null
func _ready():
	Stats.is_recuerdo = true
	unlocked_scenes = Stats.unlocked_scenes
	message_box.visible = false
	for novel in visual_novels.values():
		# Filtrar solo las escenas desbloqueadas
		if not novel["sceneName"] in unlocked_scenes:
			continue  # Saltar si la escena no está desbloqueada

		var button = Button.new()
		button.text = novel["buttonName"]
		
		# Crear y aplicar un Theme personalizado
		var theme = Theme.new()
		var font = load("res://fuentes/my_font.tres")  # Asegúrate de tener una fuente válida
		theme.set_font("font", "Button", font)
		theme.set_font_size("font_size", "Button", 12)
		
		# Aplicar estilos de fondo
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color(0.2, 0.2, 0.4)  # Azul oscuro
		theme.set_stylebox("normal", "Button", normal_style)
		
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color(0.3, 0.3, 0.5)  # Azul más claro
		theme.set_stylebox("hover", "Button", hover_style)
		
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = Color(0.1, 0.1, 0.3)  # Azul más oscuro
		theme.set_stylebox("pressed", "Button", pressed_style)
		
		# Aplicar colores de fuente
		theme.set_color("font_color", "Button", Color(1, 1, 1))  # Blanco
		theme.set_color("font_color_pressed", "Button", Color(0.8, 0.8, 0.8))  # Gris
		
		# Asignar el theme al botón
		button.theme = theme
		
		# Ajustes de tamaño
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		# Conectar evento
		button.pressed.connect(func(): show_novel_preview(novel))
		grid_container.add_child(button)

func show_novel_preview(novel):
	selected_novel = novel
	texture_rect.texture = load(novel["backgroundImage"])
	message_label.text = "¿Quieres cargar " + novel["buttonName"] + "?"
	message_box.visible = true
	animate_message_box(true)

func animate_message_box(show: bool):
	var tween = create_tween()
	message_box.modulate.a = 0 if show else 1
	tween.tween_property(message_box, "modulate:a", 1 if show else 0, 0.3)
	if not show:
		await tween.finished
		message_box.visible = false

func _on_accept_button_pressed():
	if selected_novel:
		Stats.visualNovel = selected_novel["sceneName"]
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")

func _on_decline_button_pressed():
	animate_message_box(false)


func _on_button_back_pressed() -> void:
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
