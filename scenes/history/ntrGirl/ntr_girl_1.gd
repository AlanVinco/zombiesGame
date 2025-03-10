extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"
@onready var Havany = $"../../HavanyNpcState"
@onready var decision_manager = $"../../DecisionManager"

var nextScene = "res://scenes/maps/house.tscn"
var current_node = "NTR1"
var esceneMarket1 = "res://scenes/visualnovel.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	if Stats.MALO == 0:
		office.NTR_GIRL.connect(ntr_history)
		#DECISION
		decision_manager.decision_taken.connect(_on_decision_taken)
		decision_manager.current_node = current_node


func ntr_history():
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	player.visible = false
	player.move = false
	Havany.visible = true
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	mostrar_acto(Acto, actos)

var Acto = 1

var actos = {
	1: { "textos": ["ntrgirl1_txt1",], "personaje": "RATZWEL", "emocion": "NORMAL" },
	2: { "textos": ["ntrgirl1_txt2", "ntrgirl1_txt3"], "personaje": "HAVANY", "emocion": "NORMAL" },
	3: { "textos": ["ntrgirl1_txt4", "ntrgirl1_txt5"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	4: { "textos": ["ntrgirl1_txt6",], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["ntrgirl1_txt7"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	6: { "textos": ["ntrgirl1_txt8",], "personaje": "RATZWEL", "emocion": "NORMAL" },
	7: { "textos": ["ntrgirl1_txt9",], "personaje": "HAVANY", "emocion": "NORMAL" },
	8: { "textos": ["ntrgirl1_txt10", "ntrgirl1_txt11"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	9: { "textos": ["ntrgirl1_txt12",], "personaje": "HAVANY", "emocion": "NORMAL" },
	10: { "textos": ["ntrgirl1_txt13",], "personaje": "RATZWEL", "emocion": "NORMAL" },
	11: { "textos": ["ntrgirl1_txt14", "ntrgirl1_txt15", "ntrgirl1_txt16"], "personaje": "HAVANY", "emocion": "NORMAL" },
	12: { "textos": ["ntrgirl1_txt17",], "personaje": "RATZWEL", "emocion": "NORMAL" },
	13: { "textos": ["ntrgirl1_txt18", "ntrgirl1_txt19"], "personaje": "HAVANY", "emocion": "NORMAL" },
	15: { "textos": ["ntrgirl1_resp1"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	17: { "textos": ["ntrgirl1_resp2"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	elif acto_numero == 14:
		$"../../CanvasLayer".visible = true
		decision_manager.mostrar_decision()
	elif acto_numero == 16:
		#VISUAL NOVEL
		Stats.visualNovel = "ntrvisual1"
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(esceneMarket1)
		
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		#Stats.ntrGirl = 1
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)

#NUEVO
func _on_decision_taken(opcion):
	print(opcion,  "eligio opcion")
	if opcion == "aceptar":
		Stats.ntrGirl = 1
		mostrar_acto(15, actos)
	elif opcion == "rechazar":
		
		Stats.ntrGirl = 0
		mostrar_acto(17, actos)
