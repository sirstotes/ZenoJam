extends "Base Enemy.gd"

var walking_left = true

onready var bullet_holder = get_node("../../Enemy Bullets")
onready var player = $"../../Player"

var last_position = Vector2()
var collided_buffer = 0
var time_until_next_shot = 0
var rng = RandomNumberGenerator.new()
export(Vector2) var timings = Vector2(2,4)
var bullet = preload("res://Objects/Bullets/Enemy-Bullet.tscn")

func _ready():
	time_until_next_shot = rng.randf_range(timings.x, timings.y)
	rng.randomize()
	$Sprite.texture = set_color("blue", "pent")

func _physics_process(delta):
	time_until_next_shot -= delta
	if time_until_next_shot < 0:
		time_until_next_shot = rng.randf_range(timings.x, timings.y)
		var bullet_instance = bullet.instance()
		bullet_instance.set_direction(player.global_position - global_position)
		bullet_instance.global_position = self.global_position
		bullet_holder.add_child(bullet_instance)
		
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
