class_name GateLever
extends Area2D


@export var gates : Array[Gate]
@onready var polygon_2d: Polygon2D = $Polygon2D


func on_hit() -> void:
	if gates:
		for gate in gates:
			gate.queue_free()
		gates.clear()
		polygon_2d.scale.x = -1
