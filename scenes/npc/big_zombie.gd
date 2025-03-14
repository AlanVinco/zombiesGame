class_name EnemyBoss
extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var label = $Label
@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine

@export var damage = 5
@export var life = 100

var is_dead = false  # Nueva variable

@onready var zombie_wander_state: ZombieWanderState = $FiniteStateMachine/ZombieWanderState as ZombieWanderState
@onready var zombie_idle_state: ZombieIdleState = $FiniteStateMachine/ZombieIdleState as ZombieIdleState
@onready var enemy_chase_player_state: EnemyChasePlayerState = $FiniteStateMachine/EnemyChasePlayerState as EnemyChasePlayerState
@onready var zombie_jump_state: ZombieJumpState = $FiniteStateMachine/ZombieJumpState as ZombieJumpState
@onready var zombie_caer_state: ZombieCaerState = $FiniteStateMachine/ZombieCaerState as ZombieCaerState
@onready var zombie_die_state: ZombieDieState = $FiniteStateMachine/ZombieDieState as ZombieDieState

@onready var zombie_charge_state: ZombieChargeState = $FiniteStateMachine/ZombieChargeState as ZombieChargeState

@export var is_scene = false
@export var move_manually = false
@export var move_to: Vector2

@onready var animations = $Animations

signal animMorir 
signal endScene

var sprite_offset = Vector2(-28, -31)  # Offset fijo para centrar el sprite

func _ready():
	updateHPbar()
	
	# No cambiar estados si está muerto
	zombie_wander_state.found_player.connect(func(): if !is_dead: fsm.change_state(enemy_chase_player_state))
	enemy_chase_player_state.lost_player.connect(func(): if !is_dead: fsm.change_state(zombie_wander_state))
	zombie_idle_state.see_player.connect(func(): if !is_dead: fsm.change_state(zombie_wander_state))
	zombie_wander_state.jump.connect(func(): if !is_dead: fsm.change_state(zombie_jump_state))
	zombie_jump_state.terminar_de_brincar.connect(func(): if !is_dead: fsm.change_state(zombie_caer_state))
	zombie_caer_state.termino_de_caer.connect(func(): if !is_dead: fsm.change_state(enemy_chase_player_state))
	enemy_chase_player_state.charge_signal.connect(func(): if !is_dead: fsm.change_state(zombie_charge_state))
	zombie_charge_state.charge_finished.connect(func(): if !is_dead: fsm.change_state(enemy_chase_player_state))
	
	# 🔴 Bloquear FSM al morir
	zombie_die_state.muerto.connect(_on_enemy_died)


@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	if player_node:
		# Convierte la posición global del jugador a coordenadas locales del enemigo
		var player_local_position = to_local(player_node.global_position)
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
		fsm.change_state(zombie_die_state)


func _on_enemy_died():
	await get_tree().create_timer(1.0).timeout
	endScene.emit()
#
#func update_sprite_direction():
	#if player_node:
		#if velocity.x < 0:  # Si se mueve hacia la izquierda
			#animations.flip_h = true
			##animations.position.x = -26
		#elif velocity.x > 0:  # Si se mueve hacia la derecha
			#animations.flip_h = false
			##animations.position.x = -26

#Damage

func _on_timer_make_damage_timeout() -> void:
	player_node.decrease_life(damage)


func _on_area_dañar_player_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_dead == false:
		$TimerMakeDamage.start()
		body.decrease_life(damage)

func _on_area_dañar_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$TimerMakeDamage.stop()

func decrease_boos_life():
	life -= player_node.damage
	updateHPbar()

	if life <= 0:  # Si la vida llega a 0, activa el estado de muerte
		check_death()
