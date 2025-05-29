class_name Jump
extends State


func enter() -> void:
	#print('jump state entered')
	player.velocity.y = player.JUMP_VELOCITY


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
