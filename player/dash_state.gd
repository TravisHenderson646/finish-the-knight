class_name Dash
extends State


func enter() -> void:
	#print('dash state entered')
	player.dash_duration_timer.start()


func update() -> void:
	if player.dash_duration_timer.is_stopped:
		if player.is_on_floor():
			if player.direction.x == 0:
				state_machine.change_state(state_machine.states_list.run)
			else:
				state_machine.change_state(state_machine.states_list.idle)
		else:
			state_machine.change_state(state_machine.states_list.fall)
		return
	player.velocity.x = player.dash_direction * player.dash_speed
	player.velocity.y = 0
