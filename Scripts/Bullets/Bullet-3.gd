extends KinematicBody2D
var damage = 5
var timeAlive = 0
var lifeTime = 100
var linear_velocity = Vector2(0, 0)
var speed_multiplier = 20

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
	
	var velocity = move_and_slide(linear_velocity)
	if linear_velocity.angle()-velocity.angle() >= 1.5:
		linear_velocity=linear_velocity.rotated(-PI/2)
	else:
		linear_velocity = velocity.normalized()*linear_velocity.length()
	var self_chunk = int(floor(global_position.x/screen_size))
	wrap(self_chunk)
	rotation += delta*2
func _on_Bullet_body_entered(body):
	if body.health != null:
		body.health -= damage
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

func move_handler(new_chunk):
	var self_chunk = int(floor(global_position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
