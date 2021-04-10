extends Node2D

signal new_chunk(chunk)

onready var player = $Player
onready var screen_1 = $"Screen 1"
onready var screen_2 = $"Screen 2"
onready var screen_3 = $"Screen 3"

var screen_size = 64 * 15
var screen_height = 64 * 9
var last_chunk = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var chunk = int(floor(player.position.x/screen_size))
	if last_chunk != chunk:
		emit_signal("new_chunk", chunk)
	last_chunk = chunk
	if chunk % 3 == 0:
		screen_1.position.x = (chunk * screen_size)
		screen_2.position.x = (chunk * screen_size) + screen_size
		screen_3.position.x = (chunk * screen_size) - screen_size
	if chunk % 3 == 1 or chunk % 3 == -2:
		screen_1.position.x = (chunk * screen_size) - screen_size
		screen_2.position.x = (chunk * screen_size) 
		screen_3.position.x = (chunk * screen_size) + screen_size
	if chunk % 3 == 2 or chunk % 3 == -1:
		screen_1.position.x = (chunk * screen_size) + screen_size
		screen_2.position.x = (chunk * screen_size) - screen_size
		screen_3.position.x = (chunk * screen_size)
	flip_screens(screen_1)
	flip_screens(screen_2)
	flip_screens(screen_3)
		
func flip_screens(screen):
	if int(floor((screen.position.x/screen_size)/3)) % 2 == 0:
		screen.scale.y = 1
		screen.position.y = 0
	else:
		screen.scale.y = -1
		screen.position.y = screen_height

func get_chunk():
	return int(floor(player.position.x/screen_size))
