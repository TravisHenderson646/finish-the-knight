class_name Jump
extends State


func enter() -> void:
	#print('jump state entered')
	player.velocity.y = player.JUMP_VELOCITY
	player.jump_buffer_timer.stop()
	var dust := Particle.create_particle(Vector2(player.position.x, player.position.y + 2), Vector2(-player.direction.x/2.0, 1)/3.0, 10)
	player.get_tree().root.add_child(dust)


func exit() -> void:
	pass


func update() -> void:
	if player.dash():
		return
	if player.double_jump():
		return
	player.attack()
	player.apply_gravity()
	player.apply_direction()
	if !Input.is_action_pressed('jump'):
		player.velocity.y = -player.velocity.y * player.jump_release_snap
		state_machine.change_state(state_machine.states_list.fall)
	if player.velocity.y > 0:
		state_machine.change_state(state_machine.states_list.fall)
