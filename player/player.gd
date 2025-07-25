class_name Player
extends CharacterBody2D

@onready var camera_remote_transform_2d: RemoteTransform2D = $CameraRemoteTransform2D
@onready var state_machine: StateMachine = $StateMachine
@onready var drill: Area2D = $Drill
@onready var hurtbox: Area2D = $Hurtbox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction := Vector2i()
var coins := 0
var previous_animation:String

@export_category('Movement Stats')
@export var SPEED := 40.0
@export var gravity:= 3.33

@export_category('Jump Stats')
@export var jump_unlocked = true
@export var double_jump_unlocked = true
@export var JUMP_VELOCITY := -100.0
@export var jump_release_snap := 0.5
var can_jump := false
var jump_buffer_timer := FrameTimer.new(5, self)
var jump_coyote_timer := FrameTimer.new(4, self)
var double_jump_count = 1

@export_category('Dash Stats')
@export var dash_unlocked = true
@export var dash_duration := 7
var dash_duration_timer := FrameTimer.new(dash_duration, self)
@export var dash_speed := 150.0
@export var dash_cooldown := 30
var dash_cooldown_timer := FrameTimer.new(dash_cooldown, self)
var dash_buffer_timer = FrameTimer.new(5, self)
var dash_on_cooldown := false
var dashing := false
var can_dash := false
var dash_count := 0
var dash_remaining_ticks := 0
enum DASH_DIRECTIONS {LEFT = -1, RIGHT = 1}
var dash_direction: DASH_DIRECTIONS = DASH_DIRECTIONS.RIGHT

@export_category('Attack Stats')
@export var attack_unlocked = true
@export var attack_duration := 10
var attack_duration_timer := FrameTimer.new(attack_duration, self)
@export var attack_cooldown := 30
var attack_cooldown_timer := FrameTimer.new(attack_cooldown, self)
var attack_buffer_timer := FrameTimer.new(5, self)

@export_category('Combat Stats')
@export var iframes_duration := 60
var iframes_duration_timer := FrameTimer.new(iframes_duration, self)
@export var knockback_duration := 4
var knockback_duration_timer := FrameTimer.new(knockback_duration, self)
@export var knockback_speed := 120
@export var knockback_vertical := -40
enum KNOCKBACK_DIRECTIONS {LEFT = -1, RIGHT = 1}
var knockback_direction: KNOCKBACK_DIRECTIONS = KNOCKBACK_DIRECTIONS.LEFT


func _ready() -> void:
	iframes_duration_timer.timeout.connect(_on_iframes_timeout)
	remove_child(drill)
	attack_duration_timer.timeout.connect(func(): remove_child(drill))


func _physics_process(_delta: float) -> void:
	process_input()
	state_machine.update()
	move_and_slide()


func process_input():
	var raw_x_input := Input.get_axis('left', 'right')
	if raw_x_input > 0.5:
		direction.x = 1
	elif raw_x_input < -0.5:
		direction.x = -1
	else:
		direction.x = 0
	var raw_y_input := Input.get_axis('up', 'down')
	if raw_y_input > 0.5:
		direction.y = 1
	elif raw_y_input < -0.5:
		direction.y = -1
	else:
		direction.y = 0
	if Input.is_action_just_pressed('jump'):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed('dash'):
		dash_buffer_timer.start()
	if Input.is_action_just_pressed('attack'):
		attack_buffer_timer.start()


func look_around() -> void:
	# todo i dont think this function makes any sense but it works for now
	var target_y_offset := 35.0
	var look_speed := 0.04
	if Input.is_action_pressed('look up'):
		camera_remote_transform_2d.position.y = lerp(camera_remote_transform_2d.position.y, -50.0, look_speed)
	elif Input.is_action_pressed('look down'):
		camera_remote_transform_2d.position.y = lerp(
		camera_remote_transform_2d.position.y,
		target_y_offset,
		look_speed
	)
	else:
		camera_remote_transform_2d.position.y = lerp(
		camera_remote_transform_2d.position.y,
		0.0,
		look_speed
	)

func attack() -> void:
	if !attack_unlocked or attack_buffer_timer.is_stopped or !attack_cooldown_timer.is_stopped:
		return
	attack_buffer_timer.stop()
	attack_cooldown_timer.start()
	add_child(drill)
	attack_duration_timer.start()
	previous_animation = animated_sprite_2d.animation
	animated_sprite_2d.play('attack')

func dash() -> bool:
	if !dash_unlocked or dash_buffer_timer.is_stopped or !dash_cooldown_timer.is_stopped or !dash_count or !attack_duration_timer.is_stopped:
		return false
	state_machine.change_state(state_machine.states_list.dash)
	return true


func jump() -> bool:
	if !jump_unlocked or jump_buffer_timer.is_stopped:
		return false
	state_machine.change_state(state_machine.states_list.jump)
	return true


func double_jump() -> bool:
	if !double_jump_unlocked or jump_buffer_timer.is_stopped or !double_jump_count:
		return false
	state_machine.change_state(state_machine.states_list.double_jump)
	return true


func apply_direction() -> void:
	if direction.x:
		velocity.x = direction.x * SPEED
		if direction.x == 1:
			dash_direction = DASH_DIRECTIONS.RIGHT
			animated_sprite_2d.flip_h = false
		else:
			dash_direction = DASH_DIRECTIONS.LEFT
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = 0


func apply_gravity() -> void:
	velocity.y += gravity


func pogo() -> void:
	state_machine.change_state(state_machine.states_list.fall)
	velocity.y = JUMP_VELOCITY/1.5
	dash_count = 1
	double_jump_count = 1


func get_hit(body) -> void:
	if !iframes_duration_timer.is_stopped:
		return

	UI.hp -= 1
	UI.update_hp()
	if UI.hp <= 0:
		on_no_hp()
	if body.global_position.x > global_position.x:
		knockback_direction = KNOCKBACK_DIRECTIONS.LEFT
	else:
		knockback_direction = KNOCKBACK_DIRECTIONS.RIGHT
	iframes_duration_timer.start()
	state_machine.change_state(state_machine.states_list.knockback)


func on_no_hp() -> void:
	print('game over!')


func _on_iframes_timeout() -> void:
	var bodies := hurtbox.get_overlapping_bodies()
	if bodies:
		get_hit(bodies[0])
	var areas := hurtbox.get_overlapping_areas()
	if areas:
		get_hit(areas[0])


func _on_drill_area_entered(area: Area2D) -> void:
	if area is GoldDeposit:
		area.on_hit()
	if area is GateLever:
		area.on_hit()
	if area.is_in_group('pogoable'):
		pogo()


func _on_drill_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.get_hit()
	if body is BreakableTile:
		body.destroy()
	if body.is_in_group('pogoable'):
		pogo()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	print(body.get_class())
	if body is Enemy:
		get_hit(body)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	get_hit(area)


func _on_interaction_box_body_entered(body: Node2D) -> void:
	if body is Gold:
		UI.gold += 1
		UI.update_gold()
		body.destroy()


func _on_interaction_box_area_entered(area: Area2D) -> void:
	if area is DashPUP:
		dash_unlocked = true
		area.destroy()
	elif area is DoubleJumpPUP:
		double_jump_unlocked = true
		area.destroy()
	elif area is DrillPUP:
		attack_unlocked = true
		area.destroy()
	elif area is JumpPUP:
		jump_unlocked = true
		area.destroy()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == 'attack':
		animated_sprite_2d.play(previous_animation)
