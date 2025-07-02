class_name Tortoise
extends Enemy


var gravity:= 3.33
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var left_detector: Area2D = $LeftDetector
@onready var right_detector: Area2D = $RightDetector
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const speed := 15
var moving_left := false
var hp = 2
var flipped := false


func _ready() -> void:
	velocity.x = -speed


func _physics_process(_delta: float) -> void:
	velocity.y += gravity

	if hp == 2:
		if is_on_wall():
			moving_left = !moving_left
			animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

		elif is_on_floor():
			if moving_left:
				if !left_detector.get_overlapping_bodies():
					animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
					moving_left = false
			else:
				if !right_detector.get_overlapping_bodies():
					animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
					moving_left = true
		if moving_left: velocity.x = -speed
		else: velocity.x = speed
	else:
		pass


	move_and_slide()


func get_hit() -> void:
	hp -= 1
	if hp == 1:
		#could put animation logic here?
		flipped = true
		velocity.x = 0
		velocity.y = -40
		animated_sprite_2d.play('flip')
	if hp == 0:
		spawn_gold()
		spawn_particles()
		queue_free()


func spawn_gold() -> void:
	var gold = Gold.create_gold(position, Vector2(randf_range(-30, 30), -50))
	get_tree().root.call_deferred("add_child", gold)


func spawn_particles() -> void:
	var duration = 8
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, 0.5).normalized(), duration))
