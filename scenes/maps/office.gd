extends Node2D


#DECISIONS:
var Acto = 1
var current_node = "TRABAJO"
var npc_reputation = {}

const SAVE_FILE = "user://decision_tree_save.json"

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

func _ready() -> void:
	decision_manager.current_node = current_node
	decision_manager.decision_taken.connect(_on_decision_taken)
	decision_manager.cargar_arbol("res://arbol.json")
	decision_manager.cargar_progreso()
	#print(decision_manager.npc_reputation)
	decision_manager.mostrar_decision()
	#decision_manager.borrar_progreso()
	_exist_decision_taken()
	#ocultas canvaslayer de decision

func _on_decision_taken(opcion):
	pass
	#if opcion == "aceptar":
		#mostrar_acto(9)
		#Acto = 11
	#elif opcion == "rechazar":
		#mostrar_acto(11)
###SI EXISTE DECISION AGREGAR EL ACTO
func _exist_decision_taken():
	if has_value(decision_manager.npc_reputation, "npc_1"):
		if decision_manager.npc_reputation.npc_1 == 1:
			print("tiene decision")
		else:
			print("NO tiene decision")
	else:
		print("El diccionario NO tiene un valor para 'npc_1'.")

func has_value(dict: Dictionary, key: String) -> bool:
	# Verifica si la clave existe en el diccionario y si su valor no es nulo o vacío
	return dict.has(key) and dict[key] != null
