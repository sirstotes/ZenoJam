extends KinematicBody2D
var damage = 5
var timeAlive = 0
var lifeTime = 100
var linear_velocity = Vector2(0, 0)
var speed_multiplier = 20
func _process(delta):
	timeAlive += delta
	if timeAlive > lifeTime:
		queue_free()
	move_and_slide(linear_velocity)
	rotation += delta*2
func _on_Bullet_body_entered(body):
	if body.health != null:
		body.health -= damage
		queue_free()
