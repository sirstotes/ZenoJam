extends KinematicBody2D


export(float) var gravity = 980
export(float) var walk_acceleration = 5000
export(float) var friction = 5000
export(float) var max_speed = 1000
export(float) var tolerance = 1
export(float) var jump_speed = 500
export(float) var air_multiplier = 0.1
onready var base = $"../../Node2D"

var gravity_inverted = false
var velocity = Vector2()

var player_chunk = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	base.connect("new_chunk", self, "move_handler")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x -= 500 * delta
	var multiplier = air_multiplier
	if is_on_ceiling():
		velocity.y = 0
	if is_on_floor():
		multiplier = 1
		velocity.y = 0
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	move_and_slide(velocity, Vector2(0, -1))
	var self_chunk = int(floor(position.x/1920))
	wrap(self_chunk)
	if gravity_inverted:
		velocity.y += -gravity * delta
	else:
		velocity.y += gravity * delta
	

func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			position.x += 5760
		else:
			position.x -= 5760
		gravity_inverted = !gravity_inverted
		velocity.y = -velocity.y
		position.y = ((position.y - 540) * -1) + 540

func move_handler(new_chunk):
	var self_chunk = int(floor(position.x/1920))
	player_chunk = new_chunk
	wrap(self_chunk)
