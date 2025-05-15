class_name Player
extends CharacterBody2D

@export_category("Movement Stats")
@export_range(30, 50, .1) var SPEED = 40.0
@export_range(-110, -95, .1) var JUMP_VELOCITY = -100.0
@export_range(3.2, 3.5, .01) var gravity:= 3.33

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	move_and_slide()
	# prevent being 1 pixel into floor
	#if is_on_floor():
		#position.y = round(position.y)
