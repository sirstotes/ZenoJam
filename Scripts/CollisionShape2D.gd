extends KinematicBody2D

export(float) var gravity = 980
export(float) var walk_acceleration = 5000
export(float) var friction = 5000
export(float) var max_speed = 1000
export(float) var tolerance = 1
export(float) var jump_speed = 500
export(float) var air_multiplier = 0.1

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var multiplier = air_multiplier
	if is_on_ceiling():
		velocity.y = 0
	if is_on_floor():
		multiplier = 1
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -jump_speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= (walk_acceleration * delta * multiplier)
	elif Input.is_action_pressed("ui_right"):
		velocity.x += (walk_acceleration * delta * multiplier)
	elif abs(velocity.x) < friction * delta * multiplier:
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= (friction * delta * multiplier)
	elif velocity.x < 0:
		velocity.x += (friction * delta * multiplier)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	move_and_slide(velocity, Vector2(0, -1))
	velocity.y += gravity * delta
