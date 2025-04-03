extends Node2D

@onready var NPCHavany = $HavanyNpcState
@onready var NPCRatzwel = $Ratzwel
@onready var player = $Player
#DECISIONS:
var Acto = 1
var current_node = "TRABAJO"

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

signal NTR_GIRL
signal MISSION
signal on_all_texts_displayed

func _ready() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "RATZWEL_OFFICE"
	NPCRatzwel.is_scene = true
	NPCHavany.is_scene = true
	player.position = GlobalTransitions.player_position_office
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))
	

###SE QUEDA

func _on_ratzwel_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Ratzwel/ratzwelArea/ButtonTalk.visible = true
		$Ratzwel/ratzwelArea/ButtonNTR.visible = true
		$Ratzwel/ratzwelArea/ButtonMission.visible = true

func _on_ratzwel_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Ratzwel/ratzwelArea/ButtonTalk.visible = false
		$Ratzwel/ratzwelArea/ButtonNTR.visible = false
		$Ratzwel/ratzwelArea/ButtonMission.visible = false
#NTR##############################################
func _on_button_ntr_pressed() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "RATZWEL_THEME"
	emit_signal("NTR_GIRL")
	$Ratzwel/ratzwelArea/ButtonTalk.visible = false
	$Ratzwel/ratzwelArea/ButtonNTR.visible = false
	$Ratzwel/ratzwelArea/ButtonMission.visible = false

func _on_button_mission_pressed() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "RATZWEL_THEME"
	emit_signal("MISSION")
	$Ratzwel/ratzwelArea/ButtonTalk.visible = false
	$Ratzwel/ratzwelArea/ButtonNTR.visible = false
	$Ratzwel/ratzwelArea/ButtonMission.visible = false

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
		GlobalTransitions.player_position_office = player.position
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

func transformar_actos(actos):
	var new_actos = {}
	var current_index = 1
	var last_personaje = null
	var last_emocion = null
	var last_image = null
	var textos_grupo = []
	
	for key in actos.keys():
		var entry = actos[key]
		var personaje = entry["personaje"]
		var emocion = entry["emocion"]
		var image = entry["image"]
		var texto = entry["textos"][0]
		
		# Si es el mismo personaje y emoción, agrupamos los textos
		if personaje == last_personaje and emocion == last_emocion:
			textos_grupo.append(texto)
		else:
			# Si cambia de personaje o emoción, guardamos el grupo anterior
			if textos_grupo.size() > 0:
				new_actos[current_index] = {
					"textos": textos_grupo,
					"image": last_image,
					"personaje": last_personaje,
					"emocion": last_emocion
				}
				current_index += 1
			
			# Iniciamos un nuevo grupo
			textos_grupo = [texto]
			last_personaje = personaje
			last_emocion = emocion
			last_image = image
	
	# Guardar el último grupo si hay textos pendientes
	if textos_grupo.size() > 0:
		new_actos[current_index] = {
			"textos": textos_grupo,
			"image": last_image,
			"personaje": last_personaje,
			"emocion": last_emocion
		}

	return new_actos
