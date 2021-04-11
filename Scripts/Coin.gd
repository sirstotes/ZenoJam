extends KinematicBody2D
export(float) var gravity = 980
var screen_size = 64 * 15
var screen_height = 64 * 9
var player_chunk = 0
var player
var spriteoffset = 0
var velocity = Vector2(0, 0)
func _ready():
	player = get_parent().get_parent().get_node("Player")
func _process(delta):
	var self_chunk = int(floor(position.x/screen_size))
	wrap(self_chunk)
	spriteoffset += delta*3
	$Sprite.position.y = sin(spriteoffset)*5-5
	$Sprite.scale.x = cos(spriteoffset)*0.1
	move_and_slide(velocity, Vector2(0, -1))
	velocity.y += gravity * delta
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			position.x += screen_size * 3
		else:
			position.x -= screen_size * 3
		#gravity_inverted = !gravity_inverted
		#velocity.y = -velocity.y
		scale.y = -scale.y
		position.y = ((position.y - (screen_height/2)) * -1) + (screen_height/2)
func _on_new_chunk(new_chunk):
	var self_chunk = int(floor(position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.money += 1
		queue_free()
