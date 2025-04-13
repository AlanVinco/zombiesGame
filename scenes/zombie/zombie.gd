extends CharacterBody2D

enum State { IDLE, CHASING, DEAD }
signal zombie_killed  # Define la señal

signal summon_zombie_killed  # Define la señal

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var state = State.IDLE
@export var speed = 40
@export var target = null
@export var health = 50
@export var damage = 10

#knockbak
@export var knockback_strength: float = 200.0  # Fuerza del empuje
@export var knockback_duration: float = 0.2  # Duración del empuje
var is_knockback_active: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO

#DROP
@export var drop_items: Dictionary = {
	"botiquin": 20,  # 20% de probabilidad
	"comida": 45,    # 30% de probabilidad
	"dinero": 15,    # 25% de probabilidad
	"balas": 20,
}

func _ready() -> void:
	animated_sprite.play("walk")
	$Label.text = str(health)
	randomize_color()

func _physics_process(delta):
	if is_knockback_active:
		velocity = knockback_velocity
	else:
		match state:
			State.IDLE:
				idle_state(delta)
			State.CHASING:
				chase_state(delta)
			State.DEAD:
				pass  # No hacer nada en estado DEAD
				
	update_sprite_direction()
	move_and_slide()

func update_sprite_direction():
	if target:
		if velocity.x < 0:  # Si se mueve hacia la izquierda
			animated_sprite.flip_h = true
		elif velocity.x > 0:  # Si se mueve hacia la derecha
			animated_sprite.flip_h = false

func idle_state(delta):
	# Movimiento aleatorio
	$FindPlayerLayer/CollisionShape2D.scale = Vector2(1, 1)
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	velocity = random_direction * speed
	move_and_slide()

func chase_state(delta):
	if target:
		$FindPlayerLayer/CollisionShape2D.scale = Vector2(2, 2)
		var direction = (target.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		target = body
		state = State.CHASING

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		target = null
		state = State.IDLE

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$TimerDamage.start()
		body.decrease_life(damage)

func _on_timer_damage_timeout() -> void:
	if target:  # Si el jugador sigue en el área de daño
		target.decrease_life(damage)  # Aplica daño

func _on_damage_layer_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$TimerDamage.stop()

#knockbak
func apply_knockback(direction: Vector2):
	if not is_knockback_active:
		is_knockback_active = true
		knockback_velocity = direction * knockback_strength
		$KnockbackTimer.start(knockback_duration)

func _on_knockback_timer_timeout():
	is_knockback_active = false
	knockback_velocity = Vector2.ZERO

#healt
func decrease_life(value):
	health -= value
	$TimerColor.start()
	animated_sprite.modulate = Color("#a00f00")
	$Label.text = str(health)
	#Progess_bar_life.value = life
	if health <= 0:
		emit_signal("zombie_killed") 
		summon_zombie_killed.emit(self)
		state = State.DEAD  # Cambia al estado DEAD
		$zombie_die.play()  # Reproduce el sonido de muerte
		animated_sprite.play("die")  # Reproduce la animación de muerte
		# Desactiva el movimiento y la detección del jugador
		set_physics_process(false)  # Detiene el _physics_process
		$FindPlayerLayer/CollisionShape2D.set_deferred("disabled", true)  # Desactiva la detección del jugador
		$DamageLayer/CollisionShape2D.set_deferred("disabled", true)  # Desactiva el área de daño
		$TimerDamage.stop()  # Detiene el Timer de daño
		drop_random_item()  # Dropea un objeto aleatorio al morir
		$CollisionShape2D.set_deferred("disabled", true)



func _on_timer_color_timeout() -> void:
	animated_sprite.modulate = Color("#ffffff")

#func _on_zombie_die_finished() -> void:
	#queue_free()
func drop_random_item():
	var total_probability = 0
	for item in drop_items:
		total_probability += drop_items[item]
	
	var random_value = randf_range(0, total_probability)
	var cumulative_probability = 0
	
	for item in drop_items:
		cumulative_probability += drop_items[item]
		if random_value <= cumulative_probability:
			spawn_item(item)
			break

func spawn_item(item_name: String):
	var item_scene: PackedScene
	match item_name:
		"botiquin":
			item_scene = preload("res://scenes/drops/botiquin.tscn")
		"comida":
			item_scene = preload("res://scenes/drops/comida.tscn")
		"dinero":
			item_scene = preload("res://scenes/drops/dinero.tscn")
		"balas":
			item_scene = preload("res://scenes/drops/balas.tscn")
		_:
			return  # Si no hay coincidencia, no hacer nada
	
	var item_instance = item_scene.instantiate()
	item_instance.position = position  # El objeto aparece en la posición del zombie
	get_parent().add_child(item_instance)  # Añade el objeto a la escena principal

func randomize_color():
	# Verificamos si el sprite tiene un ShaderMaterial
	if animated_sprite.material:
		# Creamos una COPIA ÚNICA del material para este zombie
		var new_material = animated_sprite.material.duplicate()
		animated_sprite.material = new_material
		
		# Establecemos el color objetivo (el que queremos reemplazar)
		new_material.set_shader_parameter("target_color", Color(0.26, 0.26, 0.26, 1)) # #424242
		
		# Generamos un color aleatorio
		var random_color = Color(randf(), randf(), randf(), 1.0) 
		
		# Aplicamos el color aleatorio solo a este zombie
		new_material.set_shader_parameter("new_color", random_color)
