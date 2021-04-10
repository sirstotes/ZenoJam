extends CanvasLayer
var started = false
var fadeMod = 1
var labelMod = 0
func _ready():
	get_tree().paused = true
func _process(delta):
	if fadeMod > 0.1:
		fadeMod -= delta/4
	else:
		if started:
			$Label.visible = false
		else:
			labelMod += delta/2
	$Label.modulate = Color(0, 0, 0, labelMod)
	$ColorRect.modulate = Color(0, 0, 0, fadeMod)
	if Input.is_action_just_pressed("shoot"):
		started = true
		get_tree().paused = false
