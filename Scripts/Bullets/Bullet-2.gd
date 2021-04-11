extends KinematicBody2D
var damage = 2
var timeAlive = 0
var lifeTime = 10
var linear_velocity = Vector2(0, 0)
var speed_multiplier = 1

var screen_size = 64 * 15
var screen_height = 64 * 9

var player_chunk = 0
var gravity_inverted = false

onready var base = $"../../../Node2D"

func _ready():
	player_chunk = base.get_chunk()
	base.connect("new_chunk", self, "move_handler")

func _process(delta):
	timeAlive += delta
	if timeAlive > lifeTime:
		queue_free()
	var collision = move_and_collide(linear_velocity)
	var self_chunk = int(floor(global_position.x/screen_size))
	wrap(self_chunk)
	if collision != null:
		linear_velocity = linear_velocity.bounce(collision.normal)
	rotation = deg2rad(90)+atan2(linear_velocity.y, linear_velocity.x)
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			global_position.x += screen_size * 3
		else:
			global_position.x -= screen_size * 3
		gravity_inverted = !gravity_inverted
		linear_velocity.y = -linear_velocity.y
		global_position.y = ((global_position.y - (screen_height/2)) * -1) + (screen_height/2)

func move_handler(new_chunk):
	var self_chunk = int(floor(global_position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
	
	
