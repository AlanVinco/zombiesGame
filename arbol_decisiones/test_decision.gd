extends Control

@onready var lbl_texto = $DecisionLabel
@onready var opciones_container = $ChoicesContainer

var decision_tree = {}
var current_node = "inicio"
var npc_reputation = {}  # Diccionario para manejar la reputación de los NPCs

const SAVE_FILE = "user://decision_tree_save.json"

func _ready():
	#borrar_progreso()
	cargar_arbol("res://arbol.json")
	cargar_progreso()
	mostrar_decision()
	print(npc_reputation)  # Mostrará la reputación actual del NPC
	#print(npc_reputation["npc_1"])  # Mostrará la reputación actual del NPC


func cargar_arbol(ruta):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if file:
		decision_tree = JSON.parse_string(file.get_as_text())
		file.close()

func mostrar_decision():
	if current_node in decision_tree:
		var nodo = decision_tree[current_node]
		
		lbl_texto.text = nodo["texto"]

		# Limpiar opciones anteriores
		for child in opciones_container.get_children():
			child.queue_free()
		
		# Crear botones dinámicamente
		for opcion in nodo["opciones"]:
			var btn = Button.new()
			btn.text = opcion
			btn.pressed.connect(func(): elegir_opcion(opcion))
			opciones_container.add_child(btn)

func elegir_opcion(opcion):
	if current_node in decision_tree:
		var nodo = decision_tree[current_node]
		if opcion in nodo["opciones"]:
			aplicar_cambios(nodo["opciones"][opcion]["cambios"])
			current_node = nodo["opciones"][opcion]["siguiente"]
			guardar_progreso()  # Guardar el progreso
			mostrar_decision()

func aplicar_cambios(cambios):
	for key in cambios:
		if key.begins_with("npc_"):  # Verifica si es un NPC
			if key in npc_reputation:
				npc_reputation[key] += cambios[key]
			else:
				npc_reputation[key] = cambios[key]  # Si no existe, se inicializa
			print("Reputación de ", key, " ahora es ", npc_reputation[key])
		else:
			print("Cambio en " + key + ": " + str(cambios[key]))

# -------------------- 🚀 GUARDADO Y CARGA 🚀 --------------------

func guardar_progreso():
	var save_data = {
		"current_node": current_node,
		"npc_reputation": npc_reputation  # Guardamos la reputación de los NPCs
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Progreso guardado en: ", SAVE_FILE)

func cargar_progreso():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var save_data = JSON.parse_string(content)
		if save_data:
			if "current_node" in save_data:
				current_node = save_data["current_node"]
			if "npc_reputation" in save_data:
				npc_reputation = save_data["npc_reputation"]
			
			print("Progreso cargado: ", save_data)
		else:
			print("No se encontró un progreso válido.")
	else:
		print("No se encontró un archivo de guardado.")

func borrar_progreso():
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("Progreso eliminado.")
		current_node = "inicio"
		npc_reputation = {}  # Resetear la reputación
		mostrar_decision()
