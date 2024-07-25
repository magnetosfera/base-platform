class_name GroundState
extends State

func on_enter():
	animation_player.play(character.animations.idle)

func state_physics_process(delta) -> void:
	if character.is_on_floor():
		character.has_jumped = false
		character.previous_wall_normal = 0
		character.walk(delta)

	if not character.is_on_floor() and character.has_jumped == false and character.velocity.y >= 80:
		transitioned.emit("AirState", { 'from_state': name })
		
func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if character.is_on_floor():
			character.jump()
		elif not character.is_on_floor() and character.velocity.y <= 40:
			character.jump()
