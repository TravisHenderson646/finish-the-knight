class_name Fall
extends State


func enter() -> void:
	#print('fall state entered')
	pass


func update() -> void:
	if player.dash():
		return
	if player.double_jump():
		return
	player.attack()
	player.apply_gravity()
	player.apply_direction()
	if player.is_on_floor():
		if player.direction.x == 0:
			state_machine.change_state(state_machine.states_list.idle)
		else:
			state_machine.change_state(state_machine.states_list.run)
