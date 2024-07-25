class_name LandingState
extends State

@export var landing_animation_name : String = "landing"
@export var ground_state : State

func state_physics_process(delta):
	if character.is_on_floor(): 
		transitioned.emit("GroundState", {})
