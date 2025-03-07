extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Stats.missions == 0:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "MISSION1", "ms1_txt")
		actos = text.actos
		text.on_all_texts_displayed.connect(_on_all_texts_displayed)
		office.MISSION.connect(mission_history)
		#print(actos)

func mission_history():
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	mostrar_acto(Acto, actos)

#CARGAR TEXTOS
var Acto = 1
var scene = "res://scenes/history/misiones/mision_1.tscn"
var actos = {}
@onready var text = $"../../TEXT"

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
		
	else:
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
