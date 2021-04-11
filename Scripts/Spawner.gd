extends Node2D
export var thingsToSpawn = [preload("res://Objects/Enemies/Walker.tscn"), preload("res://Objects/Enemies/Jumper.tscn"), 
							preload("res://Objects/Enemies/Floater.tscn"), preload("res://Objects/Enemies/Directional Shooter.tscn"),
							preload("res://Objects/Enemies/Hexagon Shooter.tscn")]
export var weights = [125, 100, 50, 5, 0]
export var spawnTime = 5
export var maxEnemies = 10
var spawnWait = 0
onready var player = $"../../Player"
var total_chance = 0

var screen_size = 64 * 15
var screen_height = 64 * 9

func _ready():
	for i in weights:
		total_chance += i
	spawnWait = randi()%5
func _process(delta):
	spawnWait += delta
	if spawnWait > spawnTime and get_parent().get_parent().get_node("Enemies").get_child_count() < maxEnemies:
		spawnWait = 0
		spawn()
		maxEnemies += 1
		update_weights([weights[0]-5, weights[1]-5, weights[2]+5, weights[3]+5, weights[4]+5])
func spawn():
	var possiblePositions = []
	for c in get_children():
		if not c.is_on_screen():
			possiblePositions.append(c)
	if len(possiblePositions) > 1:
		var pos = possiblePositions[randi()%(len(possiblePositions))].global_position
		var rand_selection = randi()%(total_chance)
		var rand_index = len(weights)
		for i in range(len(weights)):
			rand_selection -= weights[i]
			if rand_selection < 0:
				rand_index = i
				break
		var spawn = thingsToSpawn[rand_index].instance()
		spawn.global_position = pos
		var up = randf() > 0
		spawn.player_chunk = int(floor(player.global_position.x/screen_size))
		spawn.scale.y = spawn.scale.y if up else -spawn.scale.y
		spawn.gravity_inverted = !up
		if spawn.is_in_group("Enemy"):
			get_parent().get_parent().get_node("Enemies").add_child(spawn)
		get_parent().get_parent().connect("new_chunk", spawn, "move_handler")
func update_weights(input):
	weights = input
	for i in weights:
		total_chance += i
