extends "Base Enemy.gd"

var walking_left = true

var last_position = Vector2()
var collided_buffer = 0

func _ready():
	$Sprite.texture = set_color("blue", "tri")

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
	$Sprite.rotation += delta * velocity.x/20
	last_position = position
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		gravity_inverted = !gravity_inverted
		scale.y = -scale.y
