extends Node2D


#DECISIONS:
var Acto = 1
var current_node = "TRABAJO"

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

func _ready() -> void:
	_exist_decision_taken()
	decision_manager.decision_taken.connect(_on_decision_taken)
	#ocultas canvaslayer de decision

###SI EXISTE DECISION AGREGAR EL ACTO
func _exist_decision_taken():
	print(Stats.ntrGirl)
	#CUANDO CARGA Y YA EXISTE UNA DECISION
	if Stats.ntrGirl == 1:
		print("YA TRABAJA")
		decision_manager.current_node = "TRABAJOTRUE"
	elif Stats.ntrGirl == 0:
		print("No trabaja")
		decision_manager.current_node = current_node
	decision_manager.mostrar_decision()
	
func _on_decision_taken(opcion):
	if opcion == "aceptar":
		Stats.ntrGirl = 1
		#QUITAAAAAAAAAAAAAAR*****
		decision_manager.guardar_progreso()
	elif opcion == "rechazar":
		Stats.ntrGirl = 0
