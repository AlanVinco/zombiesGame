class_name Enemy 
extends CharacterBody2D

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state: EnemyWanderState = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state: EnemyChaseState = $FiniteStateMachine/EnemyChaseState as EnemyChaseState

func _ready():
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_wander_state))
#FIND MOUSE
@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	ray_cast_2d.target_position = get_local_mouse_position()
