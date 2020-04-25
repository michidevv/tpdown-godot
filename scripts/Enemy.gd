extends KinematicBody2D

enum { FOLLOW, HURT }

export var speed = 60
export var push_speed = 320
export(NodePath) var target_path

var friction = push_speed * 3
var velocity = Vector2.ZERO
var state = FOLLOW

onready var sprite = $Sprite

var t = null
func _ready():
	if target_path:
		t = get_node(target_path)

func _physics_process(delta):
	match state:
		HURT:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			velocity = move_and_slide(velocity)
			if (velocity == Vector2.ZERO): state = FOLLOW
		FOLLOW:
			velocity = (global_position.direction_to(t.global_position)).normalized() if t else Vector2.ZERO
			rotation = velocity.angle()
			velocity = move_and_slide(velocity * speed)

func receive_damage(_damage, hit_position):
#	velocity = Vector2(push_speed, 0).rotated(hit_position.angle())
	state = HURT
	velocity = hit_position.normalized() * push_speed
	flash()

func flash():
	sprite.material.set_shader_param("enabled", true)
	yield(get_tree().create_timer(1.0), "timeout")
	sprite.material.set_shader_param("enabled", false)
#	sprite.self_modulate = Color(2.0, 2.0, 2.0, 1.0)
