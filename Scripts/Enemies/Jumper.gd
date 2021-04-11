extends "Base Enemy.gd"

var walking_left = true

var last_position = Vector2()
var collided_buffer = 0

func _ready():
	base.connect("new_chunk", self, "move_handler")
	$Sprite.texture = set_color("blue", "square")

func _physics_process(delta):
	base_stuff(delta)
	
