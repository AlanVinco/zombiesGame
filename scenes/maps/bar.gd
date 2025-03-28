extends Node2D
@onready var player = $Player

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

signal pedir_aumento
signal pedir_trabajo
signal on_all_texts_displayed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#quitar
	position_npc()
	$HavanyNpcState.is_scene = true
	player.position = GlobalTransitions.player_position_bar

	# Conectar dinámicamente las señales de todas las áreas
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))

#Areas:
var scene_paths = {
	"city": "res://scenes/maps/city.tscn",
}
func _on_area_entered(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = true
			button.pressed.connect(_on_button_pressed.bind(area.name))

func _on_area_exited(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = false
			button.pressed.disconnect(_on_button_pressed.bind(area.name))

func _on_button_pressed(area_name: String) -> void:
	if area_name in scene_paths:
		GlobalTransitions.player_position_bar = player.position
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

#TEXT
@export var TextScene: PackedScene

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	emit_signal("on_all_texts_displayed")
#NEXT

func _on_ratzwel_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if Stats.girlWork == 0:
			$Mesero/ratzwelArea/ButtonWork.visible = true
		else:
			$Mesero/ratzwelArea/ButtonAumento.visible = true

func _on_ratzwel_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Mesero/ratzwelArea/ButtonWork.visible = false
		$Mesero/ratzwelArea/ButtonAumento.visible = false

func _on_button_work_pressed() -> void:
	$Mesero/ratzwelArea/ButtonWork.visible = false
	$Mesero/ratzwelArea/ButtonAumento.visible = false
	emit_signal("pedir_trabajo")

func _on_button_aumento_pressed() -> void:
	$Ratzwel/ratzwelArea/ButtonWork.visible = false
	$Ratzwel/ratzwelArea/ButtonAumento.visible = false
	emit_signal("pedir_aumento")

func position_npc():
	if Stats.girlWork < 2:
		$NPCS.visible = true
		$NPCS2.visible = false
		$NPCS3.visible = false
		$watch1/CollisionShape2D.disabled = true
		$watch2/CollisionShape2D.disabled = true
		
	if Stats.girlWork == 2:
		$NPCS.visible = true
		$NPCS2.visible = true
		$NPCS3.visible = false
		$watch1/CollisionShape2D.disabled = false
		$watch2/CollisionShape2D.disabled = true
	if Stats.girlWork == 3:
		$NPCS3.visible = true
		$NPCS.visible = false
		$NPCS2.visible = false
		$watch1/CollisionShape2D.disabled = true
		$watch2/CollisionShape2D.disabled = false


func _on_watch_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$watch1/Button.visible = true

func _on_watch_1_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$watch1/Button.visible = false

func _on_watch_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$watch2/Button.visible = true

func _on_watch_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$watch2/Button.visible = false
