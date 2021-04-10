extends "Base Enemy.gd"

var walking_left = true

var last_position = Vector2()
var collided_buffer = 0
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	base.connect("new_chunk", self, "move_handler")
	$Sprite.texture = set_color("blue")

func _physics_process(delta):
	base_stuff(delta)
	if abs(last_position.x - position.x) < 0.01 and collided_buffer <= 0:
		collided_buffer = 200
		walking_left = !walking_left
	collided_buffer -= 1
	if walking_left:
		velocity.x -= walk_acceleration * delta
	else:
		velocity.x += walk_acceleration * delta
	last_position = position
