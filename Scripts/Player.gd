extends KinematicBody2D

signal end()
export(float) var gravity = 980
export(float) var walk_acceleration = 5000
export(float) var friction = 5000
export(float) var max_speed = 500
export(float) var tolerance = 1
export(float) var jump_speed = 500
export(float) var air_multiplier = 0.1
export(int) var max_health = 3
export(int) var regen_time = 10

var health = 0
var velocity = Vector2()
var last_position = Vector2()
var collided_buffer = 0
var money = 0
var health_regen = 0
var on_healer = false

var bulletAmounts = [INF, 0, 0, 0]
const BULLETS = [preload("res://Objects/Bullets/Bullet-1.tscn"), preload("res://Objects/Bullets/Bullet-2.tscn"), preload("res://Objects/Bullets/Bullet-3.tscn"), preload("res://Objects/Bullets/Bullet-4.tscn")]
var bullet_selected = 0
func _ready():
	$Gun.connect("on_shoot", self, "_on_gun_shoot")
func _physics_process(delta):
	if abs(last_position.x - position.x) < 0.01 and collided_buffer <= 0:
		collided_buffer = 10
		velocity.x = 0
	collided_buffer -= 1
	var multiplier = air_multiplier
	if is_on_ceiling():
		velocity.y = 1
	if is_on_floor():
		multiplier = 1
		velocity.y = 0
		if Input.is_action_pressed("move-up"):
			$Jump.play()
			velocity.y = -jump_speed
	if Input.is_action_pressed("move-left"):
		velocity.x -= (walk_acceleration * delta * multiplier)
	elif Input.is_action_pressed("move-right"):
		velocity.x += (walk_acceleration * delta * multiplier)
	elif abs(velocity.x) < friction * delta * multiplier:
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= (friction * delta * multiplier)
	elif velocity.x < 0:
		velocity.x += (friction * delta * multiplier)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	last_position = position
	move_and_slide(velocity, Vector2(0, -1))
	velocity.y += gravity * delta
	if health >= max_health:
		die()
func _process(delta):
	health_regen += delta
	if health_regen > (regen_time/3 if on_healer else regen_time) and health > 0: 
		health_regen = 0
		health -= 1
	$Gun.bullet = BULLETS[bullet_selected]
	if on_healer:
		modulate = Color(sin(health_regen*10)/2+1.5, 0.75, 0.75, 1)
		$Gun.cooldownWaited = 0 
	else:
		modulate = Color(1, 1, 1, 1)
func damage(amount):
	health += amount
	health_regen = 0
func die():
	visible = false
	emit_signal("end")
func _on_gun_shoot():
	bulletAmounts[bullet_selected] -= 1
func _on_Healer_body_entered(body):
	if body == self:
		$Health.play()
		on_healer = true
func _on_Healer_body_exited(body):
	if body == self:
		on_healer = false
