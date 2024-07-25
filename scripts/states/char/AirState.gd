class_name AirState
extends State

var has_double_jump : bool = true

func on_enter():
	animation_player.play(character.animations.jump)
		
func on_exit():
	has_double_jump = true

func state_physics_process(delta):
	if character.direction == 0:
		apply_air_resistance(delta)
		
	if character.direction != 0:
		handle_air_acceleration(delta)

	if Input.is_action_just_released("jump") and character.velocity.y < character.movement_data.jump_velocity / 2:
		character.velocity.y = character.movement_data.jump_velocity / 2
		
	if character.is_on_wall():
		transitioned.emit("WallState", { "from_state": name })
			
	if character.is_on_floor():
		transitioned.emit("GroundState", {})
		
func state_input(event : InputEvent):
	if event.is_action_pressed("jump") and has_double_jump and character.has_jumped:
		double_jump()

func double_jump():
	character.velocity.y = character.movement_data.jump_velocity * character.movement_data.double_jump_modifier
	animation_player.play(character.animations.double_jump)
	has_double_jump = false
	#character.previous_wall_normal = 0

func apply_air_resistance(delta):
	character.velocity.x = move_toward(character.velocity.x, 0, character.movement_data.air_resistance * delta)
	
func handle_air_acceleration(delta):
	character.velocity.x = move_toward(character.velocity.x, character.movement_data.speed * character.direction, character.movement_data.air_acceleration * delta)
