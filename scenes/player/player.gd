extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var bullets: PackedScene
@onready var hitbox = $Hitbox
enum State {
	IDLE,
	MOVING,
	ATTACKING,
	SHOOTING,
	DASH,
}

#HEALTH
@export var health = 100
@export var armor = 0
@export var damage = 5

#MOVE
@export var speed: float = 200.0
var current_state: State = State.IDLE
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN  # Por defecto, mirando hacia abajo

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
	change_state(State.IDLE)
	$Label.text = str(health)

func _process(delta):
	match current_state:
		State.IDLE:
			handle_idle_state()
		State.MOVING:
			handle_moving_state(delta)
		State.DASH:
			handle_dash_state(delta)
	# Manejar el cooldown del dash
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func change_state(new_state: State):
	current_state = new_state
	match current_state:
		State.IDLE:
			animated_sprite.play("player_idle")
		State.MOVING:
			update_walking_animation()
		State.ATTACKING:
			update_attack_animation()
		State.SHOOTING:
			update_shoot_animation()
		State.DASH:
			animated_sprite.play("dash")
#IDLE
func handle_idle_state():
	direction = Vector2.ZERO
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(State.MOVING)
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
		change_state(State.IDLE)
		
	# Intentar atacar si se presiona la tecla de ataque
	try_attack()
	try_shoot()

	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		change_state(State.DASH)
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
	if Input.is_action_just_pressed("shot") and not is_shooting:
		$AnimatedShot.play("shot_animated")
		$Shotsound.play()
		create_bullet()
		is_shooting = true
		change_state(State.SHOOTING)
		# Detener el movimiento mientras se dispara
		velocity = Vector2.ZERO
		# Actualizar el flip_h según la posición del mouse
		update_flip_h_based_on_mouse()
		# Esperar a que la animación de disparo termine
		await animated_sprite.animation_finished

		# Volver al estado IDLE o MOVING después del disparo
		is_shooting = false
		if direction != Vector2.ZERO:
			change_state(State.MOVING)
		else:
			change_state(State.IDLE)
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
		change_state(State.IDLE)
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
	if Input.is_action_just_pressed("punch1") and not is_attacking:
		$knifeSound.play()
		is_attacking = true
		$Hitbox/CollisionShape2D.disabled = false
		change_state(State.ATTACKING)
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
			change_state(State.MOVING)
		else:
			change_state(State.IDLE)

#health
func decrease_life(value):
	health -= (value - armor)
	$Label.text = str(health)
	#Progess_bar_life.value = life
	#if health <= 0:
		#emit_signal("player_death", life)

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
		collect_item(area.name)
		area.queue_free()
#inventory
@onready var inventory = $InventoryHolder/Inventory  # Referencia al inventario
func collect_item(item_name: String):
	inventory.add_item(item_name)
	print("Objeto recogido:", item_name)

func use_item(item_name: String):
	if inventory.items.has(item_name):
		match item_name:
			"Botiquin":
				health += 20  # Recupera 20 de salud
				$Label.text = str(health)
			"Comida":
				health += 10  # Recupera 10 de salud
				print("Comida consumida. Salud actual:", health)
				$Label.text = str(health)
			# Añade más casos para otros objetos
		inventory.remove_item(item_name)  # Reduce la cantidad del objeto usado
	else:
		print("No tienes", item_name, "en el inventario.")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("heal"):
		use_item("Comida")
