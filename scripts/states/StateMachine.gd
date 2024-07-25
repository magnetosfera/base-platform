class_name CharacterStateMachine
extends Node

@export var character : CharacterBody2D
@export var current_state : State
@export var animation_player : AnimationPlayer

var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.character = character
			child.animation_player = animation_player
			child.transitioned.connect(on_child_transitioned)
		else:
			push_warning("Child " + child.name + "is not a State of CharacterStateMachine")
	
	current_state.on_enter()

func _process(delta: float) -> void:
	current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	current_state.state_physics_process(delta)
	
func _input(event: InputEvent) -> void:
	current_state.state_input(event)
	
func on_child_transitioned(new_state_name: StringName, args: Dictionary) -> void:
	var new_state = states.get(new_state_name)
	
	if new_state != null:
		if new_state != current_state:
			current_state.on_exit()
			new_state.on_enter()
			current_state = new_state
			if args:
				current_state.emitted_args = args

			if args.has('from_state'):
				current_state.from_state = args['from_state']
	else:
		push_warning("Called transition on a state that does not exist")
	
func can_move() -> bool:
	return current_state.can_move
