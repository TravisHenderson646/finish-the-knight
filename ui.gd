extends CanvasLayer


@onready var coins_label: Label = %Label
var coins := 0

func _ready() -> void:
	coins_label.text = str(coins)


func update_coins() -> void:
	print('update coins')
	coins_label.text = str(coins)
