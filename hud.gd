extends Control

@onready var coins: CoinsHUD = $Coins


func update_coins() -> void:
	coins.update_count()
