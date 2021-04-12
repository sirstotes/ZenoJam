extends KinematicBody2D
export(float) var gravity = 980
var screen_size = 64 * 15
var screen_height = 64 * 9
var player_chunk = 0
var player
var spriteoffset = 0
var velocity = Vector2(0, 0)
var gravity_inverted = false
var sound = preload("res://Objects/CoinSound.tscn")
func _ready():
	player = get_parent().get_parent().get_node("Player")
func _process(delta):
	var self_chunk = int(floor(global_position.x/screen_size))
	wrap(self_chunk)
	spriteoffset += delta*3
	$Sprite.position.y = sin(spriteoffset)*5-5
	$Sprite.scale.x = cos(spriteoffset)*0.1
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if gravity_inverted:
		velocity.y += -gravity * delta
	else:
		velocity.y += gravity * delta
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			global_position.x += screen_size * 3
		else:
			global_position.x -= screen_size * 3
		gravity_inverted = !gravity_inverted
		#velocity.y = -velocity.y
		scale.y = -scale.y
		global_position.y = ((global_position.y - (screen_height/2)) * -1) + (screen_height/2)
func move_handler(new_chunk):
	var self_chunk = int(floor(global_position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var s = sound.instance()
		s.global_position = global_position
		get_parent().get_parent().add_child(s)
		body.money += 1
		queue_free()
