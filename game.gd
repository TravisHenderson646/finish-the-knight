extends Node



# World.gd
func _ready():
	# Get the Camera2D node (assumed to be a child of World)
	var camera = $Camera2D
	# Set the RemoteTransform2D's remote path to the camera
	$Player/RemoteTransform2D.remote_path = camera.get_path()
