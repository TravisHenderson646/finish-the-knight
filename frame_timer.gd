# A class that waits for the specified number of physics frames,
# emits a timeout signal, then deletes itself
class_name FrameTimer
extends Node

signal timeout

var frames_remaining := 0

func _init(frames: int, parent: Node):
	frames_remaining = frames
	parent.add_child(self)

func _physics_process(_delta):
	frames_remaining -= 1
	if frames_remaining == 0:
		timeout.emit()
		queue_free()
