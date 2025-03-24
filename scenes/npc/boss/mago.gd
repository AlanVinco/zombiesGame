class_name MageBoss
extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var label = $Label
@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine

@export var damage = 5
@export var life = 100
@export var animator: AnimatedSprite2D

var is_dead = false  # Nueva variable
@export var is_invulnerable = true
var summoned_zombies = []  # Lista de zombies invocados

@onready var mage_idle_state: MageIdleState = $FiniteStateMachine/MageIdleState as MageIdleState
@onready var mage_summon_state: MageSummonState = $FiniteStateMachine/MageSummonState as MageSummonState
@onready var mage_invulnerable_state: MageInvulnerableState = $FiniteStateMachine/MageInvulnerableState as MageInvulnerableState
@onready var mage_vulnerable_state: MageVulnerableState = $FiniteStateMachine/MageVulnerableState as MageVulnerableState
@onready var mage_hurt_state: MageHurtState = $FiniteStateMachine/MageHurtState as MageHurtState
@onready var mage_die_state: MageDieState = $FiniteStateMachine/MageDieState as MageDieState


@export var is_scene = false
@export var move_manually = false
@export var move_to: Vector2

@onready var animations = $Animations

signal animMorir 
signal endScene
signal all_zombies_defeated

@export var player_local_position = 0

var sprite_offset = Vector2(-28, -31)  # Offset fijo para centrar el sprite

@export var total_zombie = 0

func _ready():
	updateHPbar()
	
	# No cambiar estados si está muerto
	mage_idle_state.señal_invocar.connect(func(): if !is_dead: fsm.change_state(mage_summon_state))
	mage_summon_state.señal_invulnerable_disparar.connect(func(): if !is_dead: fsm.change_state(mage_invulnerable_state))
	mage_invulnerable_state.señal_poder_golpearlo_.connect(func(): if !is_dead: fsm.change_state(mage_invulnerable_state))
	mage_vulnerable_state.señal_repetir_ciclo.connect(func(): if !is_dead: fsm.change_state(mage_idle_state))
	
@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	if player_node:
		# Convierte la posición global del jugador a coordenadas locales del enemigo
		player_local_position = to_local(player_node.global_position)
		ray_cast_2d.target_position = player_local_position
		#update_sprite_direction()

func update_text(txt):
	if label:
		label.text = str(txt)

func updateHPbar():
	$CanvasLayer/ProgressBar.value = life

func _on_area_baja_salud_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		decrease_boos_life()


func check_death():
	if life <= 0 and !is_dead:
		is_dead = true  
		fsm.set_physics_process(false)  # 🔴 Desactivar FSM
		fsm.change_state(mage_die_state)
		await get_tree().create_timer(5.0).timeout
		endScene.emit()


# 📌 **Nueva función para manejar cuando un zombie muere**
func _on_zombie_died(zombie):
	print("Un zombie ha muerto:", zombie)
	summoned_zombies.erase(zombie)  

	if summoned_zombies.size() == 0:
		print("Todos los zombies han sido derrotados, el mago ahora es vulnerable")
		fsm.change_state(mage_vulnerable_state)

		
# 📌 **Nueva función para invocar zombies en MageBoss en lugar de MageSummonState**
func summon_zombies(zombie_scene: PackedScene, count: int):
	summoned_zombies.clear()

	for i in range(count):
		var zombie = zombie_scene.instantiate()
		zombie.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		zombie.summon_zombie_killed.connect(_on_zombie_died)  # 🔴 Conectar la señal a MageBoss
		summoned_zombies.append(zombie)
		get_parent().add_child(zombie)


func _on_make_damage_timeout() -> void:
	player_node.decrease_life(damage)

func _on_areaa_daño_player_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_invulnerable == true:
		$makeDamage.start()
		body.decrease_life(damage)


func _on_areaa_daño_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$makeDamage.stop()


func _on_area_entra_daño_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		if is_invulnerable == false:
			life -= player_node.damage
			updateHPbar()

		if life <= 0:  # Si la vida llega a 0, activa el estado de muerte
			check_death()


func decrease_boos_life():
	if is_invulnerable == false:
		life -= player_node.damage
		updateHPbar()

		if life <= 0:  # Si la vida llega a 0, activa el estado de muerte
			check_death()


func _on_shield_animation_finished() -> void:
	if $shield.animation == "start":
		$shield.play("idle")
