class_name GoldDeposit
extends Area2D

@onready var hit: CollisionShape2D = $Hit
@onready var unhit: CollisionShape2D = $Unhit
@onready var unhit_polygon: Polygon2D = $UnhitPolygon
@onready var hit_polygon: Polygon2D = $HitPolygon
@onready var destroyed_polygon: Polygon2D = $DestroyedPolygon

var attack_lockout_timer := FrameTimer.new(10, self)

var is_hit := false


func on_hit() -> void:
	if is_hit:
		spawn_gold()
		spawn_gold()
		unhit_polygon.polygon = destroyed_polygon.polygon
		unhit_polygon.position = destroyed_polygon.position
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		spawn_gold()
		is_hit = true
		unhit.shape.size = hit.shape.size
		unhit.position = hit.position
		unhit_polygon.polygon = hit_polygon.polygon
		unhit_polygon.position = hit_polygon.position

func spawn_gold() -> void:
	var gold = Gold.create_gold(position, Vector2(randf_range(-30, 30), -50))
	get_tree().root.add_child(gold)
	
