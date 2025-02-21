extends Node2D

@onready var player = $Player

var store_items = {
	"Botiquin": {"price": 10, "max": 5},
	"Comida": {"price": 5, "max": 10},
	"Balas": {"price": 2, "max": 9999},
	"Armadura": {"price": 50, "max": 1},
}

var cart = {}  # Diccionario para almacenar los artículos seleccionados
var player_inventory  # Referencia al inventario del jugador

func _ready():
	player_inventory = Inventory # Asegúrate de que esta referencia es correcta
	print(player_inventory.items)
	update_shop_ui()

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
	
	if player_inventory.items.get("Dinero", 0) >= total_cost:
		#player_inventory.items["Dinero"] -= total_cost
		player.use_item("Dinero", total_cost)
		for item in cart:
			#print("item que se agregara ", item)
			player.collect_item(item, cart[item])
		cart.clear()
		update_shop_ui()
		print("Compra realizada con éxito")
	else:
		print("No tienes suficiente dinero")
