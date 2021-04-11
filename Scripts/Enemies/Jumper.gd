extends "Base Enemy.gd"

var walking_left = true

var last_position = Vector2()
var collided_buffer = 0
onready var player = $"../../Player"
export(float) var jump_delay = 3.141 
export(float) var friction = 5000
export(float) var jump_speed = 500
export(float) var sideways_multiplier = 0.7
var current_delay = 0

func _ready():	
	$Sprite.texture = set_color("blue", "square")
	max_speed = 100000

func _physics_process(delta):
	var multiplier = air_multiplier
	if is_on_floor():
		multiplier = 1
	if abs(velocity.x) < friction * delta * multiplier:
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= (friction * delta * multiplier)
	elif velocity.x < 0:
		velocity.x += (friction * delta * multiplier)
	base_stuff(delta)
	current_delay += delta
	if current_delay > jump_delay:
		add_to_group("Jumping")
		current_delay = 0
		var distance = player.global_position.x - global_position.x
		print(max_speed)
		if distance > 0:
			velocity.x = jump_speed * sideways_multiplier
		else:
			velocity.x = -jump_speed * sideways_multiplier
		if gravity_inverted:
			velocity.y += jump_speed
		else:
			velocity.y -= jump_speed
	
