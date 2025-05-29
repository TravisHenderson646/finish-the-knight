extends Camera2D


func _ready():
	get_tree().get_first_node_in_group('player').camera_remote_transform_2d.remote_path = get_path()


func _process(_delta: float) -> void:
	pass
