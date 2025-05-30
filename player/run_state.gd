class_name Run
extends State


var previous_direction := 0

func enter() -> void:
	#print('run state entered')
	previous_direction = player.direction.x
	player.dash_count = 1
	player.double_jump_count = 1


func exit() -> void:
	pass


func update() -> void:
	player.dash_count = 1
	if player.dash():
		return
	if player.jump():
		return
	player.apply_direction()
	if !player.is_on_floor():
		state_machine.change_state(state_machine.states_list.fall)
		return
	if player.direction.x == 0:
		state_machine.change_state(state_machine.states_list.idle)
		return
	if previous_direction != player.direction.x:
		previous_direction = player.direction.x
		spawn_dust()


func spawn_dust() -> void:
	if player.direction.x > 0:
		var dust := Particle.new_particle(Vector2(player.position.x - 1, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 20)
		player.get_tree().root.add_child(dust)
	else:
		var dust := Particle.new_particle(Vector2(player.position.x + 8, player.position.y + 4), Vector2(-player.direction.x, -1)/3, 20)
		player.get_tree().root.add_child(dust)
