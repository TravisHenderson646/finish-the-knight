class_name Fall
extends State


func enter() -> void:
	pass
	#print('fall state entered')


func update() -> void:
	if player.dash():
		return
	player.attack()
	player.apply_gravity()
	player.apply_direction()
	if player.is_on_floor():
		state_machine.change_state(state_machine.states_list.grounded)
