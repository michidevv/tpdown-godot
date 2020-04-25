extends Node2D

var target
var timer

func init(target, timer):
	self.target = target
	position = target.position
	self.timer = timer 

func _ready():
	yield(get_tree().create_timer(timer), "timeout")
	target.scent_trail.erase(self)
	queue_free()
