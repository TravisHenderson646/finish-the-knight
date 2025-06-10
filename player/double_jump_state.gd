class_name DoubleJump
extends State


func enter() -> void:
	#print('double jump state entered')
	player.velocity.y = player.JUMP_VELOCITY * 0.785
	player.double_jump_count -= 1
	player.jump_buffer_timer.stop()
	var dust := Particle.create_particle(Vector2(player.position.x, player.position.y + 2), Vector2(-player.direction.x/2.0 + 0.75, 1)/3.0, 10)
	player.get_tree().root.add_child(dust)
	var dust2 := Particle.create_particle(Vector2(player.position.x, player.position.y + 2), Vector2(-player.direction.x/2.0 - 0.75, 1)/3.0, 10)
	player.get_tree().root.add_child(dust2)


func exit() -> void:
	pass


func update() -> void:
	if player.dash():
		return
	player.attack()
	player.apply_gravity()
	player.apply_direction()
	if !Input.is_action_pressed('jump'):
		player.velocity.y = -player.velocity.y * player.jump_release_snap
		state_machine.change_state(state_machine.states_list.fall)
	if player.velocity.y > 0:
		state_machine.change_state(state_machine.states_list.fall)
