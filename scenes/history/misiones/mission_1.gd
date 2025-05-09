extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Stats.missions == 0:
		office.MISSION.connect(mission_history)
		#print(actos)

func mission_history():
	GlobalTransitions.transition()
	text.cargar_csv("res://languages/zombies1DialogV1.csv", "MISSION1", "ms1_txt")
	actos = text.actos
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	mostrar_acto(Acto, actos)

#CARGAR TEXTOS
var Acto = 1
var scene = "res://scenes/versus_page.tscn"
var actos = {}
@onready var text = $"../../TEXT"
@export var mission_value = 2 
var versus_scene = load(scene).instantiate()

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
		versus_scene.mission = mission_value
		get_tree().current_scene.queue_free()  # Liberar la escena actual
		get_tree().root.add_child(versus_scene)  # Agregar la nueva escena
		get_tree().current_scene = versus_scene  # Definirla como la escena actual

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
