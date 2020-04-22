extends Node2D

enum { IDLE, ATTACK }

export (int) var damage = 2

var state = IDLE

onready var animation_player = $AnimationPlayer

func attack():
	state = ATTACK
	animation_player.play("attack")
	yield(animation_player, "animation_finished")
	state = IDLE


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage"):
		var hit_position = global_position.direction_to(body.global_position)
		body.receive_damage(damage, hit_position)
