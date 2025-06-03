class_name Idle
extends State

func enter() -> void:
	print('idle state entered')
	player.dash_count = 1
	player.double_jump_count = 1
	player.velocity.x = 0


func exit() -> void:
	pass


func update() -> void:
	if player.dash():
		return
	if player.jump():
		return
	if !player.is_on_floor():
		state_machine.change_state(state_machine.states_list.fall)
		return
	if player.direction.x != 0:
		spawn_dust()
		state_machine.change_state(state_machine.states_list.run)


func spawn_dust() -> void:
	if player.direction.x > 0:
		var dust := Particle.create_particle(Vector2(player.position.x - 1, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 10)
		player.get_tree().root.add_child(dust)
	else:
		var dust := Particle.create_particle(Vector2(player.position.x + 8, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 10)
		player.get_tree().root.add_child(dust)
