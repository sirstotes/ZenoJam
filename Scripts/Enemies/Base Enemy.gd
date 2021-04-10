extends KinematicBody2D

export(float) var gravity = 980
export(float) var walk_acceleration = 5000
export(float) var friction = 5000
var max_speed = 1000
export(float) var tolerance = 1
export(float) var jump_speed = 500
export(float) var air_multiplier = 0.1
var health = 0
onready var base = $"../../Node2D"

var properties = {"blue": [100, 2], "green": [200, 4], "yellow": [300, 6], "red": [400, 8]}

var screen_size = 64 * 15
var screen_height = 64 * 9

var gravity_inverted = false
var velocity = Vector2()

var player_chunk = 0
# Called when the node enters the scene tree for the first time.
func _init():
	set_color("blue")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	base_stuff(delta)
	

func base_stuff(delta):
	var multiplier = air_multiplier
	if is_on_ceiling():
		velocity.y = 0
	if is_on_floor():
		multiplier = 1
		velocity.y = 0
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("bullet") and not collision.collider.is_in_group("freeing"):
			collision.collider.add_to_group("freeing")
			collision.collider.queue_free()
			health -= collision.collider.damage
			if health == 0:
				die()
	var self_chunk = int(floor(position.x/screen_size))
	wrap(self_chunk)
	if gravity_inverted:
		velocity.y += -gravity * delta
	else:
		velocity.y += gravity * delta

func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			position.x += screen_size * 3
		else:
			position.x -= screen_size * 3
		gravity_inverted = !gravity_inverted
		velocity.y = -velocity.y
		scale.y = -scale.y
		position.y = ((position.y - (screen_height/2)) * -1) + (screen_height/2)

func die():
	queue_free()

func set_color(color):
	max_speed = properties[color][0]
	health = properties[color][1]
	return load("res://Sprites/tri-" + color + ".png")

func move_handler(new_chunk):
	var self_chunk = int(floor(position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
