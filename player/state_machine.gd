class_name StateMachine
extends Node


@onready var player = get_parent()
var state: State
var states_list: Dictionary

func _ready() -> void:
	states_list = {
		grounded = Grounded.new(player, self),
		fall = Fall.new(player, self),
		jump = Jump.new(player, self),
		dash = Dash.new(player, self),
	}
	state = states_list.grounded

func update() -> void:
	state.update()

func change_state(new_state) -> void:
	state.exit()
	state = new_state
	state.enter()
