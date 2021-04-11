extends Node2D
export var thingsToSpawn = [preload("res://Objects/Enemies/Walker.tscn"), preload("res://Objects/Enemies/Jumper.tscn"), 
							preload("res://Objects/Enemies/Floater.tscn"), preload("res://Objects/Enemies/Directional Shooter.tscn"),
							preload("res://Objects/Enemies/Hexagon Shooter.tscn")]
export var spawnTime = 5
var spawnWait = 0
onready var player = $"../../Player"

var screen_size = 64 * 15
var screen_height = 64 * 9

func _ready():
	spawnWait = randi()%5
func _process(delta):
	spawnWait += delta
	if spawnWait > spawnTime:
		spawnWait = 0
		spawn()
func spawn():
	var possiblePositions = []
	for c in get_children():
		if not c.is_on_screen():
			possiblePositions.append(c)
	if len(possiblePositions) > 1:
		var pos = possiblePositions[randi()%(len(possiblePositions))].global_position
		var rand_index = randi()%(len(thingsToSpawn))
		var spawn = thingsToSpawn[rand_index].instance()
		spawn.global_position = pos
		var up = randf() > 0
		spawn.player_chunk = int(floor(player.global_position.x/screen_size))
		spawn.scale.y = spawn.scale.y if up else -spawn.scale.y
		spawn.gravity_inverted = !up
		if spawn.is_in_group("Enemy"):
			get_parent().get_parent().get_node("Enemies").add_child(spawn)
		elif spawn.is_in_group("Coin"):
			get_parent().get_parent().get_node("Coins").add_child(spawn)
		get_parent().get_parent().connect("new_chunk", spawn, "move_handler")
