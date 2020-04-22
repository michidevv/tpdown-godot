extends KinematicBody2D

export var push_speed = 320
var friction = push_speed * 3

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)

func receive_damage(damage, hit_position):
#	velocity = Vector2(push_speed, 0).rotated(hit_position.angle())
	velocity = hit_position.normalized() * push_speed
