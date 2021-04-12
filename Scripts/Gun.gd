extends Sprite
signal on_shoot()
export var bullet = preload("../Objects/Bullets/Bullet-3.tscn")
export(NodePath) var bulletHolderPath
export var speed = 10
export var cooldown = 0.5
export var rotationOffset = 90
export var bulletLifetime = 10
var cooldownWaited = 0.5
var bulletHolder
func _ready():
	bulletHolder = get_node(bulletHolderPath)
func _process(delta):
	cooldownWaited += delta
	if cooldownWaited < cooldown:
		var c = 0.5+(cooldownWaited/cooldown)*0.5
		modulate = Color(c, c, c, 1)
	else:
		modulate = Color(1, 1, 1)
	rotation = deg2rad(rotationOffset)+atan2(get_global_mouse_position().y-global_position.y, get_global_mouse_position().x-global_position.x)
	if (Input.is_action_just_pressed("shoot") and cooldownWaited>cooldown):
		emit_signal("on_shoot")
		for child in get_children():
			var newBullet = bullet.instance()
			newBullet.global_position=child.global_position
			newBullet.linear_velocity = Vector2(0, -speed*newBullet.speed_multiplier).rotated(rotation)
			newBullet.rotation=position.angle_to(child.position)
			bulletHolder.add_child(newBullet)
		cooldownWaited = 0
		get_parent().get_node("Shoot").play()
