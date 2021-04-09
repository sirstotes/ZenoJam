extends Sprite
export var bullet = preload("Bullet-1.tscn")
export(NodePath) var bulletHolderPath
export var speed = 10
export var cooldown = 0.5
export var rotationOffset = 90
var cooldownWaited = 0
var bulletHolder
func _ready():
	bulletHolder = get_node(bulletHolderPath)
	pass # Replace with function body.
func _process(delta):
	cooldownWaited += delta
	rotation = deg2rad(rotationOffset)+atan2(get_global_mouse_position().y-global_position.y, get_global_mouse_position().x-global_position.x)
	if (Input.is_action_just_pressed("shoot") and cooldownWaited>cooldown):
		for child in get_children():
			var newBullet = bullet.instance()
			newBullet.global_position=child.global_position
			newBullet.linear_velocity = Vector2(0, -speed*newBullet.speed_multiplier).rotated(rotation)
			newBullet.rotation=rotation
			bulletHolder.add_child(newBullet)
		cooldownWaited = 0
