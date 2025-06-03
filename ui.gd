extends CanvasLayer


@onready var coins_label: Label = %Label
@onready var hp1: ColorRect = $"HUD/1HP"
@onready var hp2: ColorRect = $"HUD/2HP"
@onready var hp3: ColorRect = $"HUD/3HP"
var coins := 0
var hp := 3

func _ready() -> void:
	coins_label.text = str(coins)


func update_coins() -> void:
	coins_label.text = str(coins)


func update_hp() -> void:
	match hp:
		0:
			hp1.visible = false
			hp2.visible = false
			hp3.visible = false
		1:
			hp2.visible = false
			hp3.visible = false
		2:
			hp2.visible = true
			hp3.visible = false
		3:
			hp2.visible = true
			hp3.visible = true
