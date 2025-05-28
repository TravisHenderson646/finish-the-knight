# A class that waits for the specified number of physics frames,
# emits a timeout signal, then deletes itself
# generally used like:
# 	dashing = true
# 	FrameTimer.new(dash_duration, self).timeout.connect(func(): dashing = false)
class_name FrameTimer
extends Node

signal timeout

var total_frames: int
var frames_remaining: int
var is_stopped := true

func _init(frames: int, parent: Node):
	total_frames = frames
	parent.add_child(self)


func stop() -> void:
	is_stopped = true
	frames_remaining = 0


func start() -> void:
	frames_remaining = total_frames
	is_stopped = false


func _physics_process(_delta):
	if is_stopped:
		return
	if frames_remaining == 0:
		timeout.emit()
		is_stopped = true
	frames_remaining -= 1
