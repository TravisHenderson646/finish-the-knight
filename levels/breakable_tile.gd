class_name BreakableTile
extends StaticBody2D


func destroy() -> void:
	spawn_particles()
	queue_free()


func spawn_particles() -> void:
	var duration = 11
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.2).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.2).normalized(), duration))
