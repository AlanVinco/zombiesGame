extends Node2D

@onready var player = $Player

var store_items = {
	"Botiquin": {"price": 10, "max": 5},
	"Comida": {"price": 5, "max": 10},
	"Balas": {"price": 2, "max": 9999},
	"Armadura": {"price": 50, "max": 1},
	"Condon": {"price": 1, "max": 1},
}

signal pedir_aumento
var cart = {}  # Diccionario para almacenar los artículos seleccionados
var player_inventory  # Referencia al inventario del jugador

func _ready():
	MusicManager.music_player["parameters/switch_to_clip"] = "MARKET_THEME"
	player_inventory = Inventory # Asegúrate de que esta referencia es correcta
	$vendedor.play("idle")
	decision_manager.decision_taken.connect(_on_decision_taken)
	player.position = GlobalTransitions.player_position_market

	# Conectar dinámicamente las señales de todas las áreas
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))

func update_shop_ui():
	$Control.visible = true
	# Limpia la tienda antes de actualizar
	for child in $Control/ShopContainer.get_children():
		child.queue_free()
	
	for item in store_items.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		label.text = item + " $" + str(store_items[item]["price"])
		
		var minus_button = Button.new()
		minus_button.text = "-"
		minus_button.connect("pressed", Callable(self, "_decrease_quantity").bind(item))
		
		var quantity_label = Label.new()
		quantity_label.text = str(cart.get(item, 0))
		
		var plus_button = Button.new()
		plus_button.text = "+"
		plus_button.connect("pressed", Callable(self, "_increase_quantity").bind(item, quantity_label))
		
		hbox.add_child(label)
		hbox.add_child(minus_button)
		hbox.add_child(quantity_label)
		hbox.add_child(plus_button)
		$Control/ShopContainer.add_child(hbox)

func _increase_quantity(item, quantity_label):
	var max_stack = store_items[item]["max"]
	if cart.get(item, 0) < max_stack:
		cart[item] = cart.get(item, 0) + 1
		quantity_label.text = str(cart[item])

func _decrease_quantity(item):
	if cart.get(item, 0) > 0:
		cart[item] -= 1
		if cart[item] == 0:
			cart.erase(item)
	update_shop_ui()


func _on_button_pressed() -> void:
	var total_cost = 0
	for item in cart:
		total_cost += cart[item] * store_items[item]["price"]
		#print("Costo total: ", total_cost)
		#print("carrito ", cart[item])
	
	if GlobalInventoryItems.totalItems.get("Dinero", 0) >= total_cost:
		#player_inventory.items["Dinero"] -= total_cost
		player.use_item("Dinero", total_cost)
		for item in cart:
			#print("item que se agregara ", item)
			player.collect_item(item, cart[item])
		cart.clear()
		update_shop_ui()
		print("Compra realizada con éxito")
		$Control.visible = false
	else:
		print("No tienes suficiente dinero")
		$Control.visible = false

#VENDEDOR
func _on_vendedor_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$vendedor/vendedorArea/ButtonTalk.visible = true
		$vendedor/vendedorArea/ButtonBuy.visible = true
		if Stats.playerWork >= 2:
			$vendedor/vendedorArea/ButtonWork.visible = true
			if Stats.playerWork == 2:
				$vendedor/vendedorArea/ButtonAumento.visible = true

func _on_vendedor_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$vendedor/vendedorArea/ButtonTalk.visible = false
		$vendedor/vendedorArea/ButtonBuy.visible = false
		$vendedor/vendedorArea/ButtonWork.visible = false
		$vendedor/vendedorArea/ButtonAumento.visible = false

func _on_button_talk_pressed() -> void:
	$vendedor/vendedorArea/ButtonTalk.visible = false
	$vendedor/vendedorArea/ButtonBuy.visible = false
	$vendedor/vendedorArea/ButtonWork.visible = false
	$vendedor/vendedorArea/ButtonAumento.visible = false
	if Stats.playerWork >=2:
		mostrar_acto(21)
	elif Stats.playerWork ==1:
		mostrar_acto(14)
	else:
		mostrar_acto(Acto)
	player.move = false

func _on_button_buy_pressed() -> void:
	$vendedor/vendedorArea/ButtonTalk.visible = false
	$vendedor/vendedorArea/ButtonBuy.visible = false
	$vendedor/vendedorArea/ButtonWork.visible = false
	$vendedor/vendedorArea/ButtonAumento.visible = false
	update_shop_ui()

#TEXT*******************************************
@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/maps/house.tscn"

var actos = {
	1: { "textos": ["market_txt1"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	2: { "textos": ["market_txt2"], "personaje": "PLAYER", "emocion": "NORMAL" },
	3: { "textos": ["market_txt3"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	4: { "textos": ["market_txt4"], "personaje": "PLAYER", "emocion": "NORMAL" },
	5: { "textos": ["market_txt5", "market_txt6"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	6: { "textos": ["market_txt7"], "personaje": "PLAYER", "emocion": "NORMAL" },
	7: { "textos": ["market_txt8"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	8: { "textos": ["market_txt9"], "personaje": "PLAYER", "emocion": "NORMAL" },
	9: { "textos": ["market_txt10"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	10: { "textos": ["market_txt11"], "personaje": "PLAYER", "emocion": "NORMAL" },
	11: { "textos": ["market_txt12"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	12: { "textos": ["market_txt13"], "personaje": "PLAYER", "emocion": "NORMAL" },
	13: { "textos": ["market_txt14", "market_txt15", "market_txt16",], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	14: { "textos": ["market_txt23"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	15: { "textos": ["market_txt17", "market_txt18", "market_txt19"], "personaje": "PLAYER", "emocion": "NORMAL" },
	17:{ "textos": ["market_resp_1"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	19:{ "textos": ["market_resp_2"], "personaje": "VENDEDOR", "emocion": "NORMAL" }, 
	21: { "textos": ["market_txt20", "market_txt21", "market_txt22"], "personaje": "VENDEDOR", "emocion": "NORMAL" },
	23:{ "textos": ["txt1_actions"], "personaje": "PLAYER", "emocion": "NORMAL" }}

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
	elif acto_numero == 16:
		decision_manager.current_node = "TRABAJOPLAYER"
		$CanvasLayer.visible = true
		decision_manager.mostrar_decision()
	elif acto_numero == 18:
		#VISUAL NOVEL
		Stats.visualNovel = "market1"
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(esceneMarket1)
	else:
		$CanvasLayer.visible = false
		player.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)

#DECICION***********************************
var current_node = "TRABAJO"

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

func _on_decision_taken(opcion):
	if opcion == "aceptar":
		$SonidoVendedor.stream = load("res://sound/sounds/risaVendedor1.mp3")
		$SonidoVendedor.play()
		Stats.playerWork = 2
		Stats.restar_esposa_points("HUSBAND", 10)
		mostrar_acto(17)
		#AGREGAR PROXIMA ESCENA CON LA ESPOSA
		Acto = 19
	elif opcion == "rechazar":
		$SonidoVendedor.stream = load("res://sound/sounds/sonidoVendedorEnojado1.mp3")
		$SonidoVendedor.play()
		Stats.playerWork = 1
		mostrar_acto(19)
	##QUITAAAAAAAAAAR*************************************************************
	#decision_manager.guardar_progreso()

#TRABAJAAAR******

func _on_button_work_pressed() -> void:
	$vendedor/vendedorArea/ButtonTalk.visible = false
	$vendedor/vendedorArea/ButtonBuy.visible = false
	$vendedor/vendedorArea/ButtonWork.visible = false
	$vendedor/vendedorArea/ButtonAumento.visible = false
	if Stats.time == "day" or Stats.time == "afternoon":
		player.collect_item("Dinero", 100)
		Stats.advance_time()
		player.show_stats()
	else:
		player.move = false
		mostrar_acto(23)

#CARGAR LUGARES
var scene_paths = {
	"city": "res://scenes/maps/city.tscn",
	"house": "res://scenes/maps/house.tscn",
	# Agrega más escenas aquí si es necesario
}

func _on_area_entered(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = true
			button.pressed.connect(_on_button_pressed1.bind(area.name))

func _on_area_exited(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = false
			button.pressed.disconnect(_on_button_pressed1.bind(area.name))

func _on_button_pressed1(area_name: String) -> void:
	if area_name in scene_paths:
		Transition()
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

func Transition():
	GlobalTransitions.player_position_market = player.position

#CARGAR VISUAL NOVEL
var esceneMarket1 = "res://scenes/visualnovel.tscn"

func _on_button_aumento_pressed() -> void:
	$vendedor/vendedorArea/ButtonTalk.visible = false
	$vendedor/vendedorArea/ButtonBuy.visible = false
	$vendedor/vendedorArea/ButtonWork.visible = false
	$vendedor/vendedorArea/ButtonAumento.visible = false
	pedir_aumento.emit()
	
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
