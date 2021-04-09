extends KinematicBody2D
var damage = 1
var timeAlive = 0
var lifeTime = 10
var linear_velocity = Vector2(0, 0)
var speed_multiplier = 1
func _process(delta):
	timeAlive += delta
	if timeAlive > lifeTime:
		queue_free()
	var collision = move_and_collide(linear_velocity)
	if collision != null:
		linear_velocity = linear_velocity.bounce(collision.normal)
	rotation = deg2rad(90)+atan2(linear_velocity.y, linear_velocity.x)
func _on_Bullet_body_entered(body):
	if body.health != null:
		body.health -= damage
		queue_free()
