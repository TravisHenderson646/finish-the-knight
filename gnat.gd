class_name Gnat
extends CharacterBody2D



var chasing:Player



func _physics_process(_delta: float) -> void:
	if chasing:
		var to_player = (chasing.position - position)
		print(to_player)
		velocity = to_player
	move_and_slide()


func get_hit() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		chasing = body
