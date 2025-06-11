class_name Gold
extends CharacterBody2D

const GOLD = preload("res://gold.tscn")
const GOLD_2 = preload('res://gold_2.tscn')
var coefficient_of_restitution = 0.65


static func create_gold(_position: Vector2, _velocity: Vector2) -> Gold:
	if randf() < 0.75:
		var new_gold = GOLD.instantiate()
		new_gold.velocity = _velocity
		new_gold.position = _position
		return(new_gold)
	else:
		var new_gold = GOLD_2.instantiate()
		new_gold.velocity = _velocity
		new_gold.position = _position
		return(new_gold)


func _physics_process(_delta: float) -> void:
	velocity.y += 3.33
	var collision = move_and_collide(velocity * 1/60)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * coefficient_of_restitution


func destroy() -> void:
	spawn_particles()
	queue_free()


func spawn_particles() -> void:
	var duration = 8
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, -0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, -0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, -0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0).normalized(), duration))
