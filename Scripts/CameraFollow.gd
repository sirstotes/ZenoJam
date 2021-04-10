extends Camera2D
export(NodePath) var follow
# Called when the node enters the scene tree for the first time.
var nodeToFollow
func _ready():
	nodeToFollow = get_node(follow)
func _process(delta):
	if get_tree().paused == false:
		position = nodeToFollow.position
