class_name StateMachine
extends Node


@onready var player = get_parent()
var state: State
var states_list: Dictionary

func _ready() -> void:
	states_list = {
		run = Run.new(player, self),
		idle = Idle.new(player, self),
		fall = Fall.new(player, self),
		jump = Jump.new(player, self),
		double_jump = DoubleJump.new(player, self),
		dash = Dash.new(player, self),
	}
	state = states_list.fall

func update() -> void:
	state.update()

func change_state(new_state) -> void:
	state.exit()
	state = new_state
	state.enter()
