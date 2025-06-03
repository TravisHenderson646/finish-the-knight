class_name Knockback
extends State


func enter() -> void:
	#print('knockback state entered')
	player.velocity.y = player.knockback_vertical
	player.knockback_duration_timer.start()


func update() -> void:
	if player.knockback_duration_timer.is_stopped:
		state_machine.change_state(state_machine.states_list.fall)
	player.velocity.x = player.knockback_direction * player.knockback_speed
