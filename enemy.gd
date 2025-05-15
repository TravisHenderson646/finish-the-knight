extends CharacterBody2D


var gravity:= 3.33
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var polygon_2d: Polygon2D = $Polygon2D

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity
	velocity.x = -3

	move_and_slide()
