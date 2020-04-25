extends KinematicBody2D

enum { FOLLOW, HURT }

export var speed = 60
export var push_speed = 320
export(NodePath) var target_path

const DEFAULT_ROTATION = deg2rad(90)

var friction = push_speed * 3
var velocity = Vector2.ZERO
var state = FOLLOW

onready var sprite = $Sprite
onready var raycast = $RayCast2D

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
			chase_target_scent()

func chase_target_scent():
	if not t:
		return
		
	raycast.cast_to = t.position - position
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		chase_target(raycast.cast_to)
	else:
		for scent in t.scent_trail:
			raycast.cast_to = scent.position - position
			raycast.force_raycast_update()

			if not raycast.is_colliding():
				chase_target(raycast.cast_to)
				break
	
func chase_target(dir: Vector2):
	velocity = dir.normalized()
	sprite.rotation = velocity.angle() + DEFAULT_ROTATION
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
