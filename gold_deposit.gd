class_name GoldDeposit
extends Area2D

@onready var hitbox: Area2D = $Hitbox
@onready var hit: CollisionShape2D = $Hit
@onready var unhit: CollisionShape2D = $Unhit
@onready var destroyed: Polygon2D = $Destroyed
var attack_lockout_timer := FrameTimer.new(10, self)

var is_hit := false

func _ready() -> void:
	hit.set_deferred("disabled", true)
	hit.visible = false
	destroyed.visible = false

 
func on_hit() -> void:
	if attack_lockout_timer.is_stopped:
		if is_hit:
			hit.set_deferred("disabled", true)
			hit.visible = false
			destroyed.visible = true
		else:
			is_hit = true
			#unhit.set_deferred("disabled", true)
			#unhit.visible = false
			hit.set_deferred("disabled", false)
			hit.visible = true
	#attack_lockout_timer.start()
