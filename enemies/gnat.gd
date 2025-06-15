class_name Gnat
extends Enemy

var chasing:Player


func _physics_process(_delta: float) -> void:
	if chasing:
		var to_player = (chasing.position - position)
		velocity = to_player
	move_and_slide()


func get_hit() -> void:
	spawn_particles()
	var gold = Gold.create_gold(position, Vector2(randf_range(-30, 30), 50))
	get_tree().root.call_deferred("add_child", gold)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		chasing = body

func spawn_particles() -> void:
	var duration := 10
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(-0.5, 0.5).normalized(), duration))
	get_tree().root.add_child(Particle.create_particle(position, Vector2(0, 0.5).normalized(), duration))
