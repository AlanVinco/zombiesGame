extends CharacterBody2D

var houseScene = "res://scenes/maps/house.tscn"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var bullets: PackedScene
@onready var hitbox = $Hitbox
@export var  move = true
enum Estados {
	IDLE,
	MOVING,
	ATTACKING,
	SHOOTING,
	DASH,
}

#HEALTH
@export var health = Stats.life
@export var armor = Stats.armor
@export var damage = Stats.damage
@export var cordura = Stats.cor
@export var stamina = Stats.stamina
@export var hambre = Stats.hambre


#MOVE
@export var speed: float = Stats.speed
var current_state = Estados.IDLE
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN  # Por defecto, mirando hacia abajo

#SOUND
@onready var walkSound = $walkSound

#DASH
@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0

var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

#ATTACK1
var is_attacking: bool = false

#SHOT
var is_shooting: bool = false

func _ready():
	change_state(Estados.IDLE)
	$Label.text = str(health)
	show_stats()

func _process(delta):
	match current_state:
		Estados.IDLE:
			handle_idle_state()
		Estados.MOVING:
			handle_moving_state(delta)
		Estados.DASH:
			handle_dash_state(delta)
	# Manejar el cooldown del dash
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func change_state(new_state):
	current_state = new_state
	match current_state:
		Estados.IDLE:
			walkSound.stop()
			animated_sprite.play("player_idle")
		Estados.MOVING:
			walkSound.play()
			update_walking_animation()
		Estados.ATTACKING:
			update_attack_animation()
		Estados.SHOOTING:
			update_shoot_animation()
		Estados.DASH:
			animated_sprite.play("dash")
#IDLE
func handle_idle_state():
	direction = Vector2.ZERO
	if (Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right")) and move:
		change_state(Estados.MOVING)
	# Intentar atacar si se presiona la tecla de ataque
	try_attack()
	try_shoot()
#MOVE
func handle_moving_state(delta):
	if is_attacking or is_shooting:
		return  # No hacer nada si está atacando o disparando
		
	direction = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
# Actualizar la última dirección
		last_direction = direction

		# Cambiar la animación según la dirección
		update_walking_animation()
		
	else:
		change_state(Estados.IDLE)
		
	# Intentar atacar si se presiona la tecla de ataque
	try_attack()
	try_shoot()

	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		change_state(Estados.DASH)
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
func update_walking_animation():
	if direction.y < 0:  # Arriba
		animated_sprite.play("walk_front")
	elif direction.y > 0:  # Abajo
		animated_sprite.play("walk_front")
	elif direction.x < 0:  # Izquierda
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = true
	elif direction.x > 0:  # Derecha
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = false

#func update_idle_animation():
	#if last_direction.y < 0:  # Arriba
		#animated_sprite.play("idle_up")
	#elif last_direction.y > 0:  # Abajo
		#animated_sprite.play("idle_down")
	#elif last_direction.x < 0:  # Izquierda
		#animated_sprite.play("idle_left")
	#elif last_direction.x > 0:  # Derecha
		#animated_sprite.play("idle_right")

#SHOT
func try_shoot():
	if Input.is_action_just_pressed("shot") and not is_shooting and inventory.items.has("Balas") and move:
		use_item("Balas", 1)
		$AnimatedShot.play("shot_animated")
		$Shotsound.play()
		create_bullet()
		is_shooting = true
		change_state(Estados.SHOOTING)
		# Detener el movimiento mientras se dispara
		velocity = Vector2.ZERO
		# Actualizar el flip_h según la posición del mouse
		update_flip_h_based_on_mouse()
		# Esperar a que la animación de disparo termine
		await animated_sprite.animation_finished

		# Volver al estado IDLE o MOVING después del disparo
		is_shooting = false
		if direction != Vector2.ZERO:
			change_state(Estados.MOVING)
		else:
			change_state(Estados.IDLE)
	if Input.is_action_just_pressed("shot") and not is_shooting and !inventory.items.has("Balas"):
		$emptyGun.play()
func update_shoot_animation():
	animated_sprite.play("player_shot")
	#if last_direction.y < 0:  # Arriba
		#animated_sprite.play("shoot_up")
	#elif last_direction.y > 0:  # Abajo
		#animated_sprite.play("shoot_down")
	#elif last_direction.x < 0:  # Izquierda
		#animated_sprite.play("shoot_left")
	#elif last_direction.x > 0:  # Derecha
		#animated_sprite.play("shoot_right")
#DASH
func handle_dash_state(delta):
	dash_timer -= delta
	if dash_timer <= 0:
		change_state(Estados.IDLE)
	else:
		velocity = direction * dash_speed
		move_and_slide()

#ATTACK1

func update_attack_animation():
	animated_sprite.play("player_punch1")
	#if last_direction.y < 0:  # Arriba
		#animated_sprite.play("attack_up")
	#elif last_direction.y > 0:  # Abajo
		#animated_sprite.play("attack_down")
	#elif last_direction.x < 0:  # Izquierda
		#animated_sprite.play("attack_left")
	#elif last_direction.x > 0:  # Derecha
		#animated_sprite.play("attack_right")

func try_attack():
	if Input.is_action_just_pressed("punch1") and not is_attacking and move:
		$knifeSound.play()
		is_attacking = true
		$Hitbox/CollisionShape2D.disabled = false
		change_state(Estados.ATTACKING)
		# Detener el movimiento mientras se ataca
		velocity = Vector2.ZERO
		# Actualizar el flip_h según la posición del mouse
		update_flip_h_based_on_mouse()
		# Esperar a que la animación de ataque termine
		await animated_sprite.animation_finished

		# Volver al estado IDLE o MOVING después del ataque
		is_attacking = false
		$Hitbox/CollisionShape2D.disabled = true
		if direction != Vector2.ZERO:
			change_state(Estados.MOVING)
		else:
			change_state(Estados.IDLE)

#health
func decrease_life(value):
	health -= (value - armor)
	Stats.life = health
	$Label.text = str(health)
	#Progess_bar_life.value = life
	if health <= 0:
		player_dead()

#FLIP
func update_flip_h_based_on_mouse():
	if is_attacking or is_shooting:
		var mouse_position = get_global_mouse_position()
		if mouse_position.x < global_position.x:
			hitbox.rotation = deg_to_rad(180)
			animated_sprite.flip_h = true  # Mouse a la izquierda
			$AnimatedShot.position = Vector2(-12, -1)
			$AnimatedShot.flip_h = true
			
		else:
			hitbox.rotation = deg_to_rad(360)
			animated_sprite.flip_h = false  # Mouse a la derecha
			$AnimatedShot.position = Vector2(12, -1)
			$AnimatedShot.flip_h = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		$knifeblood.play()
		var knockback_direction = (body.position - position).normalized()
		body.apply_knockback(knockback_direction)
		body.decrease_life(damage)

#BULLET
func create_bullet():
		var bullet = bullets.instantiate()
		bullet.position = $Node2D/Marker2D.global_position
		bullet.velocity = get_global_mouse_position() - bullet.position
		bullet.bulletDamage = damage
		get_parent().add_child(bullet)

func _on_pick_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("item"):
		# Verifica si el área tiene la propiedad item_name
		if "item_name" in area:
			var item_name = area.item_name
			collect_item(item_name, 1)
			area.queue_free()

@onready var inventory = $InventoryHolder/Inventory  # Referencia al inventario

func collect_item(item_name: String, quantity):
	inventory.add_item(item_name, quantity)

func use_item(item_name: String, quantity):
	if inventory.items.has(item_name):
		match item_name:
			"Botiquin":
				health += 20
				Stats.life = health   # Recupera 20 de salud
				$Label.text = str(health)
			"Comida":
				Stats.hambre += 10  # Recupera 10 de hambre
				$Label.text = str(health)
			"Balas":
				pass
			# Añade más casos para otros objetos
		inventory.remove_item(item_name, quantity)  # Reduce la cantidad del objeto usado
		show_stats()
	else:
		print("No tienes", item_name, "en el inventario.")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("heal"):
		use_item("Botiquin", 1)
	if Input.is_action_just_pressed("eat"):
		use_item("Comida", 1)

func show_stats():
	health = Stats.life
	armor = Stats.armor
	damage = Stats.damage
	cordura = Stats.cor
	stamina = Stats.stamina
	hambre = Stats.hambre
	var time = Stats.time
	var day = Stats.day
	$LabelStats.text = "Vida: %s\nDaño: %s\nArmadura: %s\nCordura: %s \nStamina: %s \nHambre: %s \nTiempo: %s \nDias: %s" % [health, damage, armor, cordura, stamina, hambre, time, day,]

#DEAD
func player_dead():
	move = false
	Stats.hearts -=1
	#animacion de morir
	#await
	get_tree().change_scene_to_file(houseScene)
	
