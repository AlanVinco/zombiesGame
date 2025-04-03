extends Node2D

@onready var player = $Player

#AREA######	
var scene_paths = {
	"city": "res://scenes/maps/city.tscn",
	# Agrega más escenas aquí si es necesario
}

func _ready() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "GUN_THEME"
	player_inventory = Inventory
	$gunSeller.play("idle")
	#player.position = GlobalTransitions.player_position_gym

	# Conectar dinámicamente las señales de todas las áreas
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))

func _on_area_entered(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = true
			button.pressed.connect(_on_button_pressed.bind(area.name))

func _on_area_exited(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = false
			button.pressed.disconnect(_on_button_pressed.bind(area.name))

func _on_button_pressed(area_name: String) -> void:
	if area_name in scene_paths:
		Transition()
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

func Transition():
	pass
	#GlobalTransitions.player_position_gym = player.position
	
func _on_vendedor_area_body_entered(body: Node2D) -> void:
	$Gunshopfinal/vendedorArea/ButtonBuy.visible = true

func _on_vendedor_area_body_exited(body: Node2D) -> void:
	$Gunshopfinal/vendedorArea/ButtonBuy.visible = false

func _on_button_buy_pressed() -> void:
	$Gunshopfinal/vendedorArea/ButtonBuy.visible = false
	update_shop_ui()

##COMPRARfunc update_shop_ui():
var store_items = {
	"Balas": {"price": 2, "max": 9999},
	"Armadura": {"price": 50, "max": 1},
}
var cart = {}  # Diccionario para almacenar los artículos seleccionados
var player_inventory  # Referencia al inventario del jugador


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

func _on_button_sell_pressed() -> void:
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
