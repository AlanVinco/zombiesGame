class_name  State

extends Node

signal  state_finished

func _ready() -> void:
	print("inicia state")

func _enter_state():
	print("enter state")
	pass

func _exit_state():
	print("exit state")
	pass
