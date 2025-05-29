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
	if player.direction.x != 0:
		state_machine.change_state(state_machine.states_list.run)
