extends Area2D
export var tradenum = 0
export var tradeCost = 1
export var tradeCooldown = 10
export(NodePath) var pathToBase
var cooldownWaited = 0
var isPlayerNear = false
var base
var screen_size = 64 * 15
var screen_height = 64 * 9
var player_chunk = 0
var player
func _ready():
	base = get_node(pathToBase)
	base.connect("new_chunk", self, "_on_new_chunk")
	player = base.get_node("Player")
	$Message.visible = false
func _process(delta):
	$Message/Label.text = "x"+str(tradeCost)
	cooldownWaited -= delta
	if cooldownWaited < 0:
		$Message.visible = isPlayerNear
		if Input.is_action_just_released("trade") and isPlayerNear and player.money >= tradeCost:
			$Message.visible = false
			cooldownWaited = tradeCooldown
			player.money -= tradeCost
			if tradenum == 0:
				player.max_health += 1
			elif tradenum == 1:
				player.max_speed += 100
			elif tradenum == 2:
				player.get_node("Gun").bullet = load("res://Objects/Bullets/bullet-1.tscn")
			elif tradenum == 3:
				player.get_node("Gun").bullet = load("res://Objects/Bullets/bullet-2.tscn")
			elif tradenum == 4:
				player.get_node("Gun").bullet = load("res://Objects/Bullets/bullet-3.tscn")
			elif tradenum == 5:
				pass
			elif tradenum == 6:
				pass
			elif tradenum == 7:
				pass
			elif tradenum == 8:
				pass
	var self_chunk = int(floor(position.x/screen_size))
	wrap(self_chunk)
func wrap(self_chunk):
	if abs(player_chunk - self_chunk) > 1:
		if player_chunk > self_chunk:
			position.x += screen_size * 3
		else:
			position.x -= screen_size * 3
		#gravity_inverted = !gravity_inverted
		#velocity.y = -velocity.y
		scale.y = -scale.y
		position.y = ((position.y - (screen_height/2)) * -1) + (screen_height/2)
func _on_Domu_body_entered(body):
	if body.is_in_group("Player"):
		isPlayerNear = true
func _on_Domu_body_exited(body):
	if body.is_in_group("Player"):
		isPlayerNear = false
func _on_new_chunk(new_chunk):
	var self_chunk = int(floor(position.x/screen_size))
	player_chunk = new_chunk
	wrap(self_chunk)
