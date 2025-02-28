extends Node2D

@onready var PlayerNpc = $PlayerNpc
@onready var RatzwelNpc = $Ratzwel
@onready var HavanyNpc =  $HavanyNpcState

@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/history/intro_3.tscn"


var actos = {
	1: { "textos": ["intro_2_txt1_d1"], "personaje": "PLAYER", "emocion": "NORMAL" },
	2: { "textos": ["intro_2_txt2_d2"], "personaje": "HAVANY", "emocion": "NORMAL" },
	3: { "textos": ["intro_2_txt3_d3"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	4: { "textos": ["intro_2_txt4_d4"], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["intro_2_txt5_d5"], "personaje": "PLAYER", "emocion": "NORMAL" },
	6: { "textos": ["intro_2_txt6_d6"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	7: { "textos": ["intro_2_txt7_d7"], "personaje": "PLAYER", "emocion": "NORMAL" },
	8: { "textos": ["intro_2_txt8_d8"], "personaje": "HAVANY", "emocion": "NORMAL" },
	9: { "textos": ["intro_2_txt9_d9", "intro_2_txt9_d10", "intro_2_txt9_d11", "intro_2_txt9_d12", 
	"intro_2_txt9_d13", "intro_2_txt9_d14", "intro_2_txt9_d15", "intro_2_txt9_d16", "intro_2_txt9_d17", 
	"intro_2_txt9_d18", "intro_2_txt9_d19", "intro_2_txt9_d20", "intro_2_txt9_d21", "intro_2_txt9_d22", 
	"intro_2_txt9_d23", "intro_2_txt9_d24", "intro_2_txt9_d25"], "personaje": "RATZWEL", "emocion": "NORMAL" },
}

#MOVER NPC VECES
var npc_positions = 0
var player_positions = 0
var havany_positions = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RatzwelNpc.is_scene = true
	PlayerNpc.is_scene = true
	HavanyNpc.is_scene = true
	await get_tree().create_timer(2.0).timeout
	mostrar_acto(Acto)
	#MOVER NPC
	RatzwelNpc.enemy_static_follow_state.move_manually_stop.connect(_check_npc_position)
	PlayerNpc.enemy_static_follow_state.move_manually_stop.connect(_check_player_position)
	HavanyNpc.enemy_static_follow_state.move_manually_stop.connect(_check_havany_position)
	

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#text_box.finished_displaying.connect(_on_finished_displaying)
	text_box.all_texts_displayed.connect(_on_all_texts_displayed)
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	#elif acto_numero == 7:
		#pass
	#elif acto_numero == 10:
		#await get_tree().create_timer(0.5).timeout
		#get_tree().change_scene_to_file(scene)
	else:
		RatzwelNpc.move_manually = true
		RatzwelNpc.move_to = Vector2(344, 119)
		await get_tree().create_timer(0.6).timeout
		PlayerNpc.move_manually = true
		PlayerNpc.move_to = Vector2(344, 119)
		await get_tree().create_timer(0.8).timeout
		HavanyNpc.move_manually = true
		HavanyNpc.move_to = Vector2(344, 119)
		#GlobalTransitions.transition()
		#await get_tree().create_timer(0.5).timeout
		#get_tree().change_scene_to_file(scene)


func _on_all_texts_displayed():
	mostrar_acto(Acto)

func _check_npc_position():
	npc_positions +=1
	match npc_positions:
		1:	
			await get_tree().create_timer(0.1).timeout
			RatzwelNpc.move_to = Vector2(295, 86)
			RatzwelNpc.move_manually = true
		2:	
			await get_tree().create_timer(0.1).timeout
			RatzwelNpc.move_to = Vector2(298, 1)
			RatzwelNpc.move_manually = true
		3:	
			await get_tree().create_timer(0.1).timeout
			RatzwelNpc.move_to = Vector2(341, -18)
			RatzwelNpc.move_manually = true
		_:	
			$Door.play()
			RatzwelNpc.queue_free()

func _check_player_position():
	player_positions +=1
	match player_positions:
		1:	
			await get_tree().create_timer(0.1).timeout
			PlayerNpc.move_to = Vector2(295, 86)
			PlayerNpc.move_manually = true
		2:	
			await get_tree().create_timer(0.1).timeout
			PlayerNpc.move_to = Vector2(298, 1)
			PlayerNpc.move_manually = true
		3:	
			await get_tree().create_timer(0.1).timeout
			PlayerNpc.move_to = Vector2(341, -18)
			PlayerNpc.move_manually = true
		_:
			PlayerNpc.visible = false
			$Door.play()
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(scene)

func _check_havany_position():
	havany_positions +=1
	match havany_positions:
		1:	
			await get_tree().create_timer(0.1).timeout
			HavanyNpc.move_to = Vector2(295, 86)
			HavanyNpc.move_manually = true
		2:	
			await get_tree().create_timer(0.1).timeout
			HavanyNpc.move_to = Vector2(298, 1)
			HavanyNpc.move_manually = true
		3:	
			await get_tree().create_timer(0.1).timeout
			HavanyNpc.move_to = Vector2(341, -18)
			HavanyNpc.move_manually = true
		_:
			HavanyNpc.visible = false
