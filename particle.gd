class_name Particle
extends Polygon2D

var velocity: Vector2
var duration: int
const PARTICLE = preload('res://particle.tscn')

static func new_particle(_position: Vector2, _velocity: Vector2, _duration: int) -> Particle:
	var new_particle = PARTICLE.instantiate()
	new_particle.velocity =_velocity
	new_particle.duration = _duration
	new_particle.position = _position
	return(new_particle)


func _physics_process(_delta: float) -> void:
	position += velocity
	duration -= 1
	if duration == 0:
		queue_free()
