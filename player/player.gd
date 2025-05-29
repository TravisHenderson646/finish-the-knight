class_name Player
extends CharacterBody2D

@onready var camera_remote_transform_2d: RemoteTransform2D = $CameraRemoteTransform2D
@onready var state_machine: StateMachine = $StateMachine
@onready var nail: Area2D = $Nail
#enum STATES {GROUNDED, JUMP, FALL, DASH}
#var state: STATES = STATES.GROUNDED
var direction := Vector2()

@export_category('Movement Stats')
@export var SPEED := 40.0
@export var gravity:= 3.33

@export_category('Jump Stats')
@export var JUMP_VELOCITY := -100.0
@export var jump_release_snap := 0.2
var can_jump := false
var jump_buffer_timer := FrameTimer.new(5, self)

@export_category('Dash Stats')
@export var dash_duration := 7
@export var dash_speed := 150.0
@export var dash_cooldown := 30
var dash_buffer_timer = FrameTimer.new(5, self)
var dash_duration_timer := FrameTimer.new(dash_duration, self)
var dash_cooldown_timer := FrameTimer.new(dash_cooldown, self)
var dash_on_cooldown := false
var dashing := false
var can_dash := false
var dash_count := 0
var dash_remaining_ticks := 0
enum DASH_DIRECTIONS {LEFT = -1, RIGHT = 1}
var dash_direction: DASH_DIRECTIONS = DASH_DIRECTIONS.RIGHT

@export_category('Attack Stats')
@export var attack_duration := 10
@export var attack_cooldown := 30
var attack_duration_timer := FrameTimer.new(attack_duration, self)
var attack_cooldown_timer := FrameTimer.new(attack_cooldown, self)
var attack_buffer_timer := FrameTimer.new(5, self)


func _ready() -> void:
	remove_child(nail)
	attack_duration_timer.timeout.connect(func(): remove_child(nail))


func _physics_process(_delta: float) -> void:
	process_input()
	state_machine.update()
	move_and_slide()


func process_input():
	direction.x = Input.get_axis('left', 'right')
	if direction.x > 0.5:
		direction.x = 1
	elif direction.x < -0.5:
		direction.x = -1
	else:
		direction.x = 0
	direction.y = Input.get_axis('up', 'down')
	if direction.y > 0.5:
		direction.y = 1
	elif direction.y < -0.5:
		direction.y = -1
	else:
		direction.y = 0
	if Input.is_action_just_pressed('jump'):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed('dash'):
		dash_buffer_timer.start()
	if Input.is_action_just_pressed('attack'):
		attack_buffer_timer.start()


func attack() -> void:
	if attack_buffer_timer.is_stopped or !attack_cooldown_timer.is_stopped:
		return
	attack_buffer_timer.stop()
	attack_cooldown_timer.start()
	add_child(nail)
	attack_duration_timer.start()

func dash() -> bool:
	if dash_buffer_timer.is_stopped or !dash_cooldown_timer.is_stopped or !dash_count:
		return false
	dash_count -= 1
	dash_buffer_timer.stop()
	dash_cooldown_timer.start()
	state_machine.change_state(state_machine.states_list.dash)
	return true


func jump() -> bool:
	if jump_buffer_timer.is_stopped:
		return false
	jump_buffer_timer.stop()
	state_machine.change_state(state_machine.states_list.jump)
	return true


func apply_direction() -> void:
	if direction.x:
		velocity.x = direction.x * SPEED
		if direction.x == 1:
			dash_direction = DASH_DIRECTIONS.RIGHT
		else:
			dash_direction = DASH_DIRECTIONS.LEFT
	else:
		velocity.x = 0


func apply_gravity() -> void:
	velocity.y += gravity


func _on_nail_area_entered(area: Area2D) -> void:
	velocity.y = JUMP_VELOCITY/1.5
	dash_count = 1
