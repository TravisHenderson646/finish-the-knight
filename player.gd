class_name Player
extends CharacterBody2D

@export_category("Movement Stats")
@export_range(30, 50, .1) var SPEED = 40.0
@export_range(-110, -95, .1) var JUMP_VELOCITY = -100.0
@export_range(3.2, 3.5, .01) var gravity:= 3.33

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

var can_jump := true

var can_dash := true
var dash_remaining_ticks := 0
var dash_duration := 10
var dash_direction = 0
var dash_speed = 150.0


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity

	# Handle jump.
	if Input.is_action_just_pressed('jump') and can_jump:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement.
	var direction := Input.get_axis('left', 'right')
	if direction:
		velocity.x = direction * SPEED
		if dash_remaining_ticks == 0:
			if velocity.x > 0:
				dash_direction = 1
			else:
				dash_direction = -1
	else:
		velocity.x = 0

	# dash
	if Input.is_action_just_pressed('dash') and can_dash:
		dash_remaining_ticks = dash_duration
		can_jump = false
		can_dash = false
	if dash_remaining_ticks > 0:
		dash_remaining_ticks -= 1
		velocity.x = dash_direction * dash_speed
		velocity.y = 0
	print(dash_remaining_ticks > 0)


	move_and_slide()

	if is_on_floor():
		if dash_remaining_ticks != 0:
			return
		can_jump = true
		can_dash = true
