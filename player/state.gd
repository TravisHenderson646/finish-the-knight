class_name State
extends Node

var player: Player
var state_machine: StateMachine
enum STATES {grounded, fall, jump, dash}

func _init(_player: Player, _state_machine: StateMachine) -> void:
	player = _player
	state_machine = _state_machine

func enter() -> void:
	pass
func exit() -> void:
	pass
func update() -> void:
	pass
