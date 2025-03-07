# En el script de la escena principal (main_scene.gd)
extends Node2D

@export var zombie_scene: PackedScene
@export var min_zombies: int = 3
@export var max_zombies: int = 6
@onready var player = $Player
@onready var boss = $BigZombie

func _ready():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", "MISSION1FIN", "ms1_fin_txt")
	actos = text.actos
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	boss.zombie_wander_state.jump.connect(empezo_saltar)

	#RatzwelNpc.enemy_static_follow_state.move_manually_stop.connect(_check_npc_position)
	

#CARGAR TEXTOS
var Acto = 1
var scene = "res://scenes/maps/house.tscn"
var actos = {}
@onready var text = $TEXT

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
		
	else:
		Stats.missions = 1
		player.collect_item("Comida", 8)
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file(scene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)

func empezo_saltar():
	await get_tree().create_timer(2.0).timeout
	$Meteoros.set_active(true)
	
	# Desactiva la caída de meteoros después de 10 segundos
	await get_tree().create_timer(10.0).timeout
	$Meteoros.set_active(false)
