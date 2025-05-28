class_name Player
extends CharacterBody2D

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var state_machine: StateMachine = $StateMachine

#enum STATES {GROUNDED, JUMP, FALL, DASH}
#var state: STATES = STATES.GROUNDED
var direction: float

@export_category('Movement Stats')
@export var SPEED := 40.0
@export var gravity:= 3.33

@export_category('Jump Stats')
@export var JUMP_VELOCITY := -100.0
@export var jump_release_snap := 0.2
var can_jump := false
var jump_buffer_timer = FrameTimer.new(20, self)

@export_category('Dash Stats')
@export var dash_duration := 10
@export var dash_speed := 150.0
@export var dash_cooldown := 20
var dash_buffer_timer = FrameTimer.new(20, self)
var dash_duration_timer = FrameTimer.new(dash_duration, self)
var dash_on_cooldown := false
var dashing := false
var can_dash := false
var dash_remaining_ticks := 0
enum DASH_DIRECTIONS {LEFT = -1, RIGHT = 1}
var dash_direction: DASH_DIRECTIONS = DASH_DIRECTIONS.RIGHT


func _physics_process(_delta: float) -> void:
	process_input()
	state_machine.update()
	move_and_slide()


func process_input():
	direction = Input.get_axis('left', 'right')
	if Input.is_action_just_pressed('jump'):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed('dash'):
		dash_buffer_timer.start()


func dash() -> bool:
	if !dash_buffer_timer.is_stopped:
		dash_buffer_timer.stop()
		state_machine.change_state(state_machine.states_list.dash)
		return true
	return false


func jump() -> bool:
	if !jump_buffer_timer.is_stopped:
		jump_buffer_timer.stop()
		state_machine.change_state(state_machine.states_list.jump)
		return true
	return false


func apply_direction() -> void:
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			dash_direction = DASH_DIRECTIONS.RIGHT
		else:
			dash_direction = DASH_DIRECTIONS.LEFT
	else:
		velocity.x = 0


func apply_gravity() -> void:
	velocity.y += gravity
