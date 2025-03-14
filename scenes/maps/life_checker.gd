extends Node2D

@export var player: NodePath
@onready var player_node = get_node(player)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_life()
	
func check_life():
	if Stats.life <=0 and Stats.hearts >= 0:
		Stats.time = "night"
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		print("Se desmayo***********************")
		player_node.move = false
		desmayo_history()
		#Escena de  havany diciendole que lo encontraron tirado
		Stats.life = 1
		#player_node.health = 1
		#player_node.show_stats()
	if Stats.life <=0 and Stats.hearts < 0:
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		player_node.move = false
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
		print("GAME OVER")
		#pantalla de game over

#dialogo:

@onready var Havany = $"../HavanyNPC"
@onready var text = $"../TEXT"
@export var escenevisual = "res://scenes/visualnovel.tscn"
@export var sceneName = "DESMAYONORMAL"
@export var sceneCodeTxt = "desmayo1_txt"

func desmayo_history():
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	
	match Stats.MALO:
		0:		
			sceneName = "DESMAYONORMAL"
			sceneCodeTxt = "desmayo1_txt"
			$"../HavanyNpcState".visible = true
			$"../HavanyNpcState".position = Vector2(-137, 206)
			text.on_all_texts_displayed.connect(_on_all_texts_displayed)
			await get_tree().create_timer(1.0).timeout
			_on_all_texts_displayed()
		20:
			sceneName = "DESMAYONORMAL2"
			sceneCodeTxt = "desmayo2_txt"
			$"../HavanyNpcState".visible = true
			$"../HavanyNpcState".position = Vector2(-137, 206)
			text.on_all_texts_displayed.connect(_on_all_texts_displayed)
			await get_tree().create_timer(1.0).timeout
			_on_all_texts_displayed()
		40:
			sceneName = "DESMAYONORMAL3"
			sceneCodeTxt = "desmayo3_txt"
			$"../HavanyNpcState".visible = true
			$"../HavanyNpcState".position = Vector2(-137, 206)
			text.on_all_texts_displayed.connect(_on_all_texts_displayed)
			await get_tree().create_timer(1.0).timeout
			_on_all_texts_displayed()
			
		60:
			sceneName = "DESMAYONORMAL4"
			sceneCodeTxt = "desmayo4_txt"
			$"../HavanyNpcState".visible = true
			$"../HavanyNpcState".position = Vector2(-137, 206)
			text.on_all_texts_displayed.connect(_on_all_texts_displayed)
			await get_tree().create_timer(1.0).timeout
			_on_all_texts_displayed()
		_:
			pass
			##novela visual DESMAYONORMAL5
var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		$"../HavanyNpcState".queue_free()
		player_node.move = true

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	mostrar_acto(Acto, actos)
