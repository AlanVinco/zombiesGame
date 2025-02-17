extends Node

signal decision_taken(opcion)

var decision_tree = {}
var current_node = "inicio"
var npc_reputation = {}

const SAVE_FILE = "user://decision_tree_save.json"

func cargar_arbol(ruta):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if file:
		decision_tree = JSON.parse_string(file.get_as_text())
		file.close()

func mostrar_decision():
	if current_node in decision_tree:
		var nodo = decision_tree[current_node]
		get_parent().lbl_texto.text = nodo["texto"]
		
		for child in get_parent().opciones_container.get_children():
			child.queue_free()
		
		for opcion in nodo["opciones"]:
			var btn = Button.new()
			btn.text = opcion
			btn.pressed.connect(func(): elegir_opcion(opcion))
			get_parent().opciones_container.add_child(btn)

func elegir_opcion(opcion):
	if current_node in decision_tree:
		var nodo = decision_tree[current_node]
		if opcion in nodo["opciones"]:
			aplicar_cambios(nodo["opciones"][opcion]["cambios"])
			current_node = nodo["opciones"][opcion]["siguiente"]
			guardar_progreso()  # Guardar el progreso
			
			# Limpiar opciones antes de continuar
			for child in get_parent().opciones_container.get_children():
				child.queue_free()
			
			## Ocultar el contenedor de opciones
			#opciones_container.visible = false
			
			mostrar_decision()


func aplicar_cambios(cambios):
	for key in cambios:
		if key.begins_with("npc_"):
			npc_reputation[key] = npc_reputation.get(key, 0) + cambios[key]
			if npc_reputation[key] == 1:
				emit_signal("decision_taken", "aceptar")
			else:
				emit_signal("decision_taken", "rechazar")
		else:
			print("Cambio en " + key + ": " + str(cambios[key]))

func guardar_progreso():
	var save_data = {
		"current_node": current_node,
		"npc_reputation": npc_reputation
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
			current_node = save_data.get("current_node", "inicio")
			npc_reputation = save_data.get("npc_reputation", {})

func borrar_progreso():
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("Progreso eliminado.")
		current_node = "inicio"
		npc_reputation = {}  # Resetear la reputación
		#mostrar_decision()
