class_name Idle
extends State

func enter() -> void:
	pass
	#print('grounded state entered')


func exit() -> void:
	pass


func update() -> void:
	player.dash_count = 1
	if player.dash():
		return
	if player.jump():
		return
	if !player.is_on_floor():
		state_machine.change_state(state_machine.states_list.fall)
		return
	if player.direction.x != 0:
		if player.direction.x > 0:
			var dust := Particle.new_particle(Vector2(player.position.x - 1, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 20)
			player.get_tree().root.add_child(dust)
		else:
			var dust := Particle.new_particle(Vector2(player.position.x + 8, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 20)
			player.get_tree().root.add_child(dust)
		state_machine.change_state(state_machine.states_list.run)
