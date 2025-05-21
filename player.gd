class_name Player
extends CharacterBody2D

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

enum STATES {GROUNDED, JUMP, FALL, DASH}
var state: STATES = STATES.GROUNDED
var direction: float

@export_category('Movement Stats')
@export var SPEED := 40.0
@export var gravity:= 3.33

@export_category('Jump Stats')
@export var JUMP_VELOCITY := -100.0
@export var jump_release_snap := 0.2
var can_jump := false

@export_category('Dash Stats')
@export var dash_duration := 10
@export var dash_speed := 150.0
@export var dash_cooldown := 20
var dash_on_cooldown := false
var dashing := false
var can_dash := false
var dash_remaining_ticks := 0
enum DASH_DIRECTIONS {
	LEFT = -1,
	RIGHT = 1
}
var dash_direction: DASH_DIRECTIONS = DASH_DIRECTIONS.RIGHT


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity

	direction = Input.get_axis('left', 'right')
	if direction:
		velocity.x = direction * SPEED
		if dash_remaining_ticks == 0:
			if velocity.x > 0:
				dash_direction = DASH_DIRECTIONS.RIGHT
			else:
				dash_direction = DASH_DIRECTIONS.LEFT
	else:
		velocity.x = 0

	if Input.is_action_just_pressed('jump') and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY
		state = STATES.JUMP

	# dash
	if Input.is_action_just_pressed('dash') and can_dash and !dash_on_cooldown:
		can_jump = false
		can_dash = false
		dashing = true
		dash_on_cooldown = true
		FrameTimer.new(dash_cooldown, self).timeout.connect(func(): dash_on_cooldown = false)
		FrameTimer.new(dash_duration, self).timeout.connect(func(): dashing = false)
		state = STATES.DASH

	match state:
		STATES.GROUNDED:
			pass
		STATES.JUMP:
			if velocity.y > 0:
				state = STATES.FALL
				print('jump to fall')
			elif Input.is_action_just_released('jump'):
				velocity.y = -velocity.y * jump_release_snap
		STATES.FALL:
			if is_on_floor():
				state = STATES.GROUNDED
				print('fall to grounded')
		STATES.DASH:
			if dashing:
				velocity.x = dash_direction * dash_speed
				velocity.y = 0
			elif is_on_floor():
				state = STATES.GROUNDED
				print('dash to grounded')
			else:
				state = STATES.FALL
				print('dash to fall')

	move_and_slide()

	if is_on_floor():
		if dashing:
			return
		can_jump = true
		can_dash = true
