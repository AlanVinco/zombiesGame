extends Node2D

@onready var HavanyNPC = $HavanyNPC
@onready var player = $Player
@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/maps/city.tscn"


var actos = {
	1: { "textos": ["intro_3_txt1_d1", "intro_3_txt1_d2", "intro_3_txt1_d3", "intro_3_txt1_d4",
	"intro_3_txt1_d5", "intro_3_txt1_d6"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	2: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"], "personaje": "PLAYER", "emocion": "NORMAL" },
	3: { "textos": ["intro_3_txt3_d1", "intro_3_txt3_d2", "intro_3_txt3_d3", "intro_3_txt3_d4",
	"intro_3_txt3_d5"], "personaje": "HAVANY", "emocion": "NORMAL" },
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = GlobalTransitions.player_position_house_hall
	check_wife_position()
	Stats.stat_changed.connect(check_wife_position)
	#HavanyNPC.havany_status.connect(check_wife_position)
	#player.collect_item("Dinero", 500)

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		print("EMPIEZA EL JUEGO")
		player.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)

#AREAS
func _on_bed_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$BedArea/ButtonDamage.visible = true

func _on_bed_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$BedArea/ButtonDamage.visible = false

func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$ExitArea/ButtonExit.visible = true

func _on_exit_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$ExitArea/ButtonExit.visible = false

func _on_button_exit_pressed() -> void:
	Transition()
	

func Transition():
	GlobalTransitions.player_position_house_hall = player.position
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)

#######SLEEEEP################
func _on_button_damage_pressed() -> void:
	Stats.reset_day()
	if Stats.girlWork == 1:
		player.collect_item("Dinero", 100)
	if Stats.girlWork == 2:
		player.collect_item("Dinero", 200)
	if Stats.girlWork == 3:
		player.collect_item("Dinero", 300)
			# Cada tercer día se reduce el dinero en un 80%
	if fmod(Stats.day, 3) == 0 and Stats.MALO == 0:
		# Obtener el dinero actual; si no existe, se asume 0
		var current_money  = GlobalInventoryItems.totalItems.get("Dinero", 0)
		# Calcular el 20% del dinero y convertirlo a entero para evitar decimales
		var new_money = int(current_money * 0.2)
		var discount = current_money - new_money  # Monto descontado
		## Actualizar el inventario con el nuevo monto
		#Inventory.items["Dinero"] = new_money
		## Actualizar la interfaz del inventario para reflejar el cambio
		player.use_item("Dinero", discount)
		#print("Se aplicó reducción de dinero. Nuevo dinero:", new_money)
	DecisionManager.guardar_progreso()

#HAVANY STATUS
func check_wife_position():
	if Stats.time == "day" or Stats.time == "afternoon":
		$HavanyNPC.visible = true
	else:
		$HavanyNPC.visible = false
		#MOVER A LA CAMA SI NO TIENE TRABAJO
		print("MOVER A LA CAMA SI NO TIENE TRABAJO")

func transformar_actos(actos):
	var new_actos = {}
	var current_index = 1
	var last_personaje = null
	var last_emocion = null
	var last_image = null
	var textos_grupo = []
	
	for key in actos.keys():
		var entry = actos[key]
		var personaje = entry["personaje"]
		var emocion = entry["emocion"]
		var image = entry["image"]
		var texto = entry["textos"][0]
		
		# Si es el mismo personaje y emoción, agrupamos los textos
		if personaje == last_personaje and emocion == last_emocion:
			textos_grupo.append(texto)
		else:
			# Si cambia de personaje o emoción, guardamos el grupo anterior
			if textos_grupo.size() > 0:
				new_actos[current_index] = {
					"textos": textos_grupo,
					"image": last_image,
					"personaje": last_personaje,
					"emocion": last_emocion
				}
				current_index += 1
			
			# Iniciamos un nuevo grupo
			textos_grupo = [texto]
			last_personaje = personaje
			last_emocion = emocion
			last_image = image
	
	# Guardar el último grupo si hay textos pendientes
	if textos_grupo.size() > 0:
		new_actos[current_index] = {
			"textos": textos_grupo,
			"image": last_image,
			"personaje": last_personaje,
			"emocion": last_emocion
		}

	return new_actos
