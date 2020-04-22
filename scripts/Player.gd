extends KinematicBody2D

export var speed = 180
export(PackedScene) var weapon

onready var muzzle = $Position2D

var velocity = Vector2()
var w = null

func _ready():
	if weapon:
		w = weapon.instance()
#		Maybe global_position?
		w.position = muzzle.position
		add_child(w)

func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_back"):
		velocity = Vector2(-speed / 3, 0).rotated(rotation)
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	if w:
		w.attack()

func _physics_process(delta):
	get_input()
	var dir = get_global_mouse_position() - global_position
	
	if dir.length() > 5:
		rotation = dir.angle()
		velocity = move_and_slide(velocity)
