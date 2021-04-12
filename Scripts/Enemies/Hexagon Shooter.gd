extends "Base Enemy.gd"

var walking_left = true

onready var bullet_holder = get_node("../../Enemy Bullets")
onready var player = $"../../Player"

var last_position = Vector2()
var collided_buffer = 0
var time_until_next_shot = 0
var rng = RandomNumberGenerator.new()
export(Vector2) var timings = Vector2(4,6)
var bullet = preload("res://Objects/Bullets/Enemy-Bullet.tscn")

export(float) var acceleration = 1
export var speed_multiplier = [0.0005, 0.001, 0.0015, 0.002]

func _ready():
	time_until_next_shot = rng.randf_range(timings.x, timings.y)
	rng.randomize()
	$Sprite.texture = set_color("blue", "hex")
	max_speed = 100000
func _physics_process(delta):
	time_until_next_shot -= delta
	if time_until_next_shot < 0:
		time_until_next_shot = rng.randf_range(timings.x, timings.y)
		for i in range(6):
			var bullet_instance = bullet.instance()
			bullet_instance.set_direction(Vector2(1, 0).rotated($Sprite.rotation + ((PI * i)/3)))
			bullet_instance.global_position = self.global_position
			bullet_holder.add_child(bullet_instance)
		
	velocity += ((player.global_position+Vector2(0,-50))-global_position).normalized()*acceleration
	velocity.x = clamp(velocity.x, -max_speed*speed_multiplier[stage], max_speed*speed_multiplier[stage])
	velocity.y = clamp(velocity.y, -max_speed*speed_multiplier[stage], max_speed*speed_multiplier[stage])
	move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap" or collision.collider.name == "TileMap2" or collision.collider.name == "TileMap3":
			continue
		if collision.collider.is_in_group("Bullet") and not collision.collider.is_in_group("Freeing"):
			print("Bullet Contact")
			collision.collider.add_to_group("Freeing")
			collision.collider.queue_free()
			hurt(collision.collider.damage)
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
	if health == 0:
		$Face.texture = load("res://Sprites/face-5.png")
	elif health == max_health-1:
		$Face.texture = load("res://Sprites/face-4.png")
	else:
		$Face.texture = load("res://Sprites/face-3.png")
	$Sprite.rotation += delta * velocity.x/20
	last_position = position
