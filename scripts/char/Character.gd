extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var animations : AnimationNames
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_jumped: bool =  false
var previous_wall_normal: float = 0
var direction : float
var can_move: bool = true

func _physics_process(delta) -> void:
	direction = Input.get_axis("move_left", "move_right")
	apply_gravity(delta)
	move_and_slide()
	update_facing_direction()
	
func update_facing_direction() -> void:
	if not can_move:
		return
	if not is_on_wall():
		if direction > 0:
			sprite_2d.flip_h = false 
		elif direction < 0:
			sprite_2d.flip_h = true
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

func jump(wall_direction: int = 0) -> void:
	if not can_move:
		return
	velocity.y = movement_data.jump_velocity
	if state_machine.current_state.name == "WallState":
		wall_jump(wall_direction)
	has_jumped = true
	animation_player.play(animations.jump)
	state_machine.current_state.transitioned.emit("AirState", { 'from_state': state_machine.current_state.name })

func walk(delta) -> void:
	if not can_move:
		velocity.x = 0
		animation_player.play(animations.idle)
		return
	if direction != 0 :
		#character.velocity.x = character.direction * character.movement_data.speed
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)
		animation_player.play(animations.run)
	else:
		animation_player.play(animations.idle)
		#character.velocity.x = move_toward(character.velocity.x, 0, character.movement_data.speed * delta)
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func wall_jump(wall_direction: int) -> void:
	if wall_direction < 0:
		velocity.x = -movement_data.wall_jump_pushback
	if wall_direction > 0:
		velocity.x = movement_data.wall_jump_pushback
	previous_wall_normal = wall_direction

func stop():
	can_move = false
	animation_player.pause()

func unstop():
	can_move = true
	animation_player.play()
