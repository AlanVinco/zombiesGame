# En el script de la escena principal (main_scene.gd)
extends Node2D

@onready var player = $Player
@onready var boss = $BigZombie
var scene = "res://scenes/visualnovel.tscn"


func _ready():
	boss.zombie_wander_state.jump.connect(empezo_saltar)
	boss.endScene.connect(change_visual)
	player.collect_item("Balas", 500)	


func empezo_saltar():
	print("empezo a saltar")
	await get_tree().create_timer(2.0).timeout
	$Meteoros.set_active(true)
	player.set_shake(true)
	$Temblor.play()
	# Desactiva la caída de meteoros después de 10 segundos
	await get_tree().create_timer(10.0).timeout
	$Meteoros.set_active(false)
	player.set_shake(false)

func change_visual():
	##AGREGAR RECOMPENSA
	print("cambiar a visual")
	Stats.missions = 3
	Stats.visualNovel = "MISIONVISUAL1"
	#player.collect_item("Comida", 8)
	GlobalTransitions.transition()
	GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
	GlobalTransitions.player_position_city = Vector2(342, -18)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)


	
