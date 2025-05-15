extends CharacterBody2D


var gravity:= 200.0

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity
	velocity.x = -3

	move_and_slide()
