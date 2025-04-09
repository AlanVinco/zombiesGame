extends Node2D

@onready var player = $Player

func _on_mancuernas_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$mancuernas/ButtonDamage.visible = true

func _on_mancuernas_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$mancuernas/ButtonDamage.visible = false

func _on_button_damage_pressed() -> void:
	$mancuernas/ButtonDamage.visible = false
	if Stats.time == "day" or Stats.time == "afternoon":
		Stats.damage += 1
		Stats.advance_time()
		player.show_stats()
		Stats.visualNovel = "GYM"
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")
	else:
		player.move = false
		mostrar_acto(Acto)
		#DecisionManager.guardar_progreso()
#AREA######	
var scene_paths = {
	"city": "res://scenes/maps/city.tscn",
	# Agrega más escenas aquí si es necesario
}

func _ready() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "GYM_THEME"
	player.position = GlobalTransitions.player_position_gym

	# Conectar dinámicamente las señales de todas las áreas
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))

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
		Transition()
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

func Transition():
	GlobalTransitions.player_position_gym = player.position


#TEXTOS######:
@export var TextScene: PackedScene
var Acto = 1

var actos = {
	1: { "textos": ["txt1_actions"], "personaje": "PLAYER", "emocion": "NORMAL" },
}
func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		player.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)


func _on_caminadora_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$caminadora/ButtonCaminadora.visible = true

func _on_caminadora_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$caminadora/ButtonCaminadora.visible = false

func _on_button_caminadora_pressed() -> void:
	$caminadora/ButtonCaminadora.visible = false
	if Stats.time == "day" or Stats.time == "afternoon":
		Stats.armor += 1
		Stats.advance_time()
		player.show_stats()
	else:
		player.move = false
		mostrar_acto(Acto)

func _on_pc_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$pc/ButtonPc.visible = true

func _on_pc_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$pc/ButtonPc.visible = false
func _on_button_pc_pressed() -> void:
	$pc/ButtonPc.visible = false
	if Stats.time == "day" or Stats.time == "afternoon":
		Stats.cor += 30
		Stats.advance_time()
		player.show_stats()
		Stats.visualNovel = "PLAYING"
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")
	else:
		player.move = false
		mostrar_acto(Acto)
