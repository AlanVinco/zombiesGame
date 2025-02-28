extends Node

signal decision_taken(opcion)

var decision_tree = {}
var current_node = "inicio"
var npc_reputation = {}
var save_data
const SAVE_FILE = "user://decision_tree_save.json"

func _ready() -> void:
	cargar_arbol("res://arbol.json")
	#guardar_progreso()
	#borrar_progreso()
	#cargar_progreso()

func cargar_arbol(ruta):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if file:
		decision_tree = JSON.parse_string(file.get_as_text())
		file.close()

func mostrar_decision():
	if current_node in decision_tree:
		print(current_node, "CURRENT NODE")
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
		if key.begins_with("npc_") or key.begins_with("playerWork") or key.begins_with("playerWork2"):
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
		"npc_reputation": npc_reputation,
		"stats": {  
			"life": Stats.life,
			"stamina": Stats.stamina,
			"damage": Stats.damage,
			"armor": Stats.armor,
			"speed": Stats.speed,
			"cor": Stats.cor,
			"hambre": Stats.hambre,
			"time": Stats.time,
			"husband": Stats.HUSBAND,
			"malo": Stats.MALO,
			"zombie": Stats.ZOMBIE,
			"hearts": Stats.hearts,
			"days": Stats.day,
			"missions": Stats.missions,
			"inventory": GlobalInventoryItems.totalItems,
			"playerWork": Stats.playerWork,
			"girlWork": Stats.girlWork,
			"ntrGirl": Stats.ntrGirl,
			"onMission": Stats.onMission,
		},
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t")) # "\t" para formato legible
	file.close()
	print("Progreso guardado en:", SAVE_FILE)

func cargar_progreso():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		save_data = JSON.parse_string(content)
		if save_data:
			Stats.life = save_data["stats"].get("life", 100)  # Usa valores por defecto si falta una clave
			Stats.stamina = save_data["stats"].get("stamina", 50)
			Stats.damage = save_data["stats"].get("damage", 5)
			Stats.armor = save_data["stats"].get("armor", 0)
			Stats.speed = save_data["stats"].get("speed", 200)
			Stats.cor = save_data["stats"].get("cor", 100)
			Stats.hambre = save_data["stats"].get("hambre", 100)
			Stats.time = save_data["stats"].get("time", "day")
			Stats.HUSBAND = save_data["stats"].get("husband", 100)
			Stats.MALO = save_data["stats"].get("malo", 0)
			Stats.ZOMBIE = save_data["stats"].get("zombie", 0)
			Stats.hearts = save_data["stats"].get("hearts", 3)
			Stats.day = save_data["stats"].get("days", 1)
			Stats.missions = save_data["stats"].get("missions", 1)
			Stats.playerWork = save_data["stats"].get("playerWork", 0)
			Stats.girlWork = save_data["stats"].get("girlWork", 0)
			Stats.ntrGirl = save_data["stats"].get("ntrGirl", 0)
			Stats.onMission = save_data["stats"].get("onMission", false)
			
			GlobalInventoryItems.totalItems = save_data["stats"].get("inventory", {})
			
			current_node = save_data.get("current_node", "inicio")
			npc_reputation = save_data.get("npc_reputation", {})

func borrar_progreso():
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("Progreso eliminado.")
		current_node = "inicio"
		npc_reputation = {}  # Resetear la reputación
		#mostrar_decision()
