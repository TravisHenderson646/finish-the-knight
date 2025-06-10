class_name Slug
extends CharacterBody2D


var gravity:= 3.33
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var left_detector: Area2D = $LeftDetector
@onready var right_detector: Area2D = $RightDetector
const speed := 15
var moving_left := true
var hp = 2


func _ready() -> void:
	velocity.x = -speed


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity
	if is_on_wall():
		moving_left = !moving_left
	elif is_on_floor():
		if moving_left:
			if !left_detector.get_overlapping_bodies():
				moving_left = false
		else:
			if !right_detector.get_overlapping_bodies():
				moving_left = true
	if moving_left: velocity.x = -speed
	else: velocity.x = speed

	move_and_slide()


func get_hit() -> void:
	hp -= 1
	if hp == 0:
		spawn_gold()
		spawn_particles()
		queue_free()


func spawn_gold() -> void:
	var gold = Gold.create_gold(position, Vector2(randf_range(-30, 30), -50))
	get_tree().root.add_child(gold)


func spawn_particles() -> void:
	var duration = 8
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, 0.5).normalized(), duration))
