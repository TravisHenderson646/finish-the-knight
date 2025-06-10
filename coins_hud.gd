class_name CoinsHUD
extends HBoxContainer


@onready var label: Label = $Label
var coins := 0

func _ready() -> void:
	label.text = str(coins)

func update_count() -> void:
	coins += 1
	label.text = str(coins)
