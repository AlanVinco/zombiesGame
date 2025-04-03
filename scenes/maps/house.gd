extends Node2D

@onready var HavanyNPC = $HavanyNPC
@onready var player = $Player
@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/maps/city.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = GlobalTransitions.player_position_house_hall
	check_wife_position()
	Stats.stat_changed.connect(check_wife_position)
	
	if Stats.MALO ==0:
		MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_HAPPY"
	if Stats.MALO >=20 and Stats.MALO <40:
		MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_NORMAL"
	if Stats.MALO >=40 and Stats.MALO <60:
		MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_OTRA"
	if Stats.MALO >=60 and Stats.MALO <80:
		MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_PREOCUPADA"
	if Stats.MALO >=80:
		MusicManager.music_player["parameters/switch_to_clip"] = "HAVANY_CORRUPTED"

	#HavanyNPC.havany_status.connect(check_wife_position)
	#player.collect_item("Dinero", 500)

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
