class_name State
extends Node

@export var can_move : bool = true

#var wall_normal : Vector2
var character : CharacterBody2D
var animation_player : AnimationPlayer
var from_state : String = ""
var emitted_args : Dictionary = {}

signal transitioned(new_state_name: StringName)

func state_input(event: InputEvent) -> void:
	pass
	
func state_process(delta: float) -> void:
	pass
	
func state_physics_process(delta: float) -> void:
	pass
	
func on_enter() -> void:
	pass

func on_exit() -> void:
	pass
