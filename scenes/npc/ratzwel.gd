class_name Enemy 
extends CharacterBody2D

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var label = $Label
@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state: EnemyWanderState = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state: EnemyChaseState = $FiniteStateMachine/EnemyChaseState as EnemyChaseState
@onready var enemy_idle_state: EnemyIdleState = $FiniteStateMachine/EnemyIdleState as EnemyIdleState
@onready var enemy_static_follow_state: EnemyStaticFollowState = $FiniteStateMachine/EnemyStaticFollowState as EnemyStaticFollowState

@export var is_scene = false
@export var move_manually = false
@export var move_to: Vector2

func _ready():
	#DEAMBULAR
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	#SEGUIR
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_idle_state))
	enemy_idle_state.see_player.connect(fsm.change_state.bind(enemy_chase_state))
	#NUEVAS para ser NPC
	enemy_idle_state.move_manually_go.connect(fsm.change_state.bind(enemy_static_follow_state))
	enemy_static_follow_state.move_manually_stop.connect(fsm.change_state.bind(enemy_idle_state))
#FIND MOUSE
@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	ray_cast_2d.target_position = get_local_mouse_position()

func update_text(txt):
	if label:
		label.text = str(txt)
