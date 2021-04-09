extends RigidBody2D
var damage = 1
var timeAlive = 0
var lifeTime = 10
var speed_multiplier = 0
func _init():
	speed_multiplier = gravity_scale*8
func _process(delta):
	timeAlive += delta
	if timeAlive > lifeTime:
		queue_free()
func _on_Bullet_body_entered(body):
	if body.health != null:
		body.health -= damage
		queue_free()
