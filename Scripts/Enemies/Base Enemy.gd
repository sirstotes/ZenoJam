extends KinematicBody2D

export(float) var gravity = 980
export(float) var walk_acceleration = 5000
var max_speed = 1000
var max_health = 0
export(float) var tolerance = 1
export(float) var air_multiplier = 0.1
export(float) var player_damage_buffer = 1

var current_player_buffer = 0
var health = 0

var properties = {"blue": [50, 2], "green": [100, 4], "yellow": [200, 6], "red": [300, 8]}

var screen_size = 64 * 15
var screen_height = 64 * 9

var gravity_inverted = false
var velocity = Vector2()

var player_chunk = 0
var coin = preload("res://Objects/Coin.tscn")
func _init():
	set_color("blue", "tri")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	add_to_group("enemy")
	base_stuff(delta)
func base_stuff(delta):
	var multiplier = air_multiplier
	if is_on_ceiling():
		velocity.y = 0
	if is_on_floor() and !is_in_group("jumping"):
		multiplier = 1
		velocity.y = 0
	if is_in_group("jumping"): remove_from_group("jumping")
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap" or collision.collider.name == "TileMap2" or collision.collider.name == "TileMap3":
			continue
		if collision.collider.is_in_group("bullet") and not collision.collider.is_in_group("freeing"):
			print("Bullet Contact")
			collision.collider.add_to_group("freeing")
			collision.collider.queue_free()
			health += collision.collider.damage
		if collision.collider.is_in_group("Player"):
			if current_player_buffer > player_damage_buffer:
				current_player_buffer = 0
				print(collision.collider.health)
				collision.collider.damage(1)
				print("Player damage")
	current_player_buffer += delta
	if health >= max_health:
		die()
	var self_chunk = int(floor(global_position.x/screen_size))
	wrap(self_chunk)
	if gravity_inverted:
		velocity.y += -gravity * delta
	else:
		velocity.y += gravity * delta
	if health == 0:
		$Face.texture = load("res://Sprites/face-5.png")
	elif health == max_health-1:
		$Face.texture = load("res://Sprites/face-4.png")
	else:
		$Face.texture = load("res://Sprites/face-3.png")
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			global_position.x += screen_size * 3
		else:
			global_position.x -= screen_size * 3
		gravity_inverted = !gravity_inverted
		velocity.y = -velocity.y
		scale.y = -scale.y
		global_position.y = ((global_position.y - (screen_height/2)) * -1) + (screen_height/2)
func die():
	var c = coin.instance()
	c.global_position = global_position
	print(get_parent().name)
	get_parent().get_parent().get_node("Coins").add_child(c)
	queue_free()

func set_color(color, shape):
	max_speed = properties[color][0]
	max_health = properties[color][1]
	return load("res://Sprites/" + shape + "-" + color + ".png")

func move_handler(new_chunk):
	var self_chunk = int(floor(global_position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
