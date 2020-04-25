extends Node

const TIMER_LIMIT = 1.0
var timer = 0.0

func _process(delta):
	timer += delta
	if timer >= TIMER_LIMIT:
		print_fps()
		timer = 0.0

func print_fps():
	print("FPS: ", Engine.get_frames_per_second())
	
