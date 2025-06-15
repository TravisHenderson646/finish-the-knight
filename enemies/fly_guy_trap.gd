class_name  FlyGuyTrap
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var left_gold_spawn_marker: Marker2D = $LeftGoldSpawnMarker
@onready var right_gold_spawn_marker: Marker2D = $RightGoldSpawnMarker
var hp := 2


func _on_right_bait_area_entered(_area: Area2D) -> void:
	hp -= 1
	$RightBait.queue_free()
	animation_player.play('snap')
	var gold = Gold.create_gold(right_gold_spawn_marker.global_position, Vector2(randf_range(-30, 30), 50))
	get_tree().root.call_deferred("add_child", gold)

func _on_left_bait_area_entered(_area: Area2D) -> void:
	hp -= 1
	$LeftBait.queue_free()
	animation_player.call_deferred('play', 'snap')
	var gold = Gold.create_gold(left_gold_spawn_marker.global_position, Vector2(randf_range(-30, 30), 50))
	get_tree().root.call_deferred("add_child", gold)


func die() -> void:
	if hp <= 0:
		queue_free()
