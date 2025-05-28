class_name Grounded
extends State


func enter() -> void:
	print('wow')


func exit() -> void:
	pass


func update() -> void:
	if player.jump():
		return
	player.apply_direction()
	if !player.is_on_floor():
		state_machine.change_state(state_machine.states_list.fall)
