extends RigidBody2D
var damage = 1
var timeAlive = 0
var lifeTime = 3
var speed_multiplier = 0

var screen_size = 64 * 15
var screen_height = 64 * 9

var player_chunk = 0
var gravity_inverted = false

onready var base = $"../../../Node2D"

func _init():
	speed_multiplier = gravity_scale*8
func _ready():
	add_to_group("bullet")
	player_chunk = base.get_chunk()
	base.connect("new_chunk", self, "move_handler")
func _process(delta):
	timeAlive += delta
	var self_chunk = int(floor(global_position.x/screen_size))
	wrap(self_chunk)
	if timeAlive > lifeTime:
		queue_free()
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			global_position.x += screen_size * 3
		else:
			global_position.x -= screen_size * 3
		gravity_inverted = !gravity_inverted
		linear_velocity.y = -linear_velocity.y
		global_position.y = ((global_position.y - (screen_height/2)) * -1) + (screen_height/2)
		gravity_scale = -gravity_scale

func move_handler(new_chunk):
	var self_chunk = int(floor(global_position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.health += damage
		print(body.health)
		add_to_group("freeing")
		queue_free()
