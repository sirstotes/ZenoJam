extends CanvasLayer
var started = false
var fadeMod = 1
var labelMod = 0
var uiMod = 0
var player
var healthbar = preload("res://Objects/HealthBox.tscn")
func _ready():
	get_tree().paused = true
	player = get_parent().get_node("Player")
	$ColorRect.visible = true
func _process(delta):
	if fadeMod > 0.1:
		fadeMod -= delta/4
	else:
		if started:
			if (labelMod>0): labelMod -= delta
			if (uiMod<1): uiMod += delta
		else:
			if (labelMod<1): labelMod += delta/2
	$Label.modulate = Color(1, 1, 1, labelMod)
	$ColorRect.modulate = Color(1, 1, 1, fadeMod)
	$UI.modulate = Color(1, 1, 1, uiMod)
	$UI/DomuCount.text = "x"+str(get_parent().get_node("Domus").get_child_count())
	$UI/CoinCount.text = "x"+str(player.money)
	if $UI/HealthBars.get_child_count() != player.health:
		for child in $UI/HealthBars.get_children():
			$UI/HealthBars.remove_child(child)
		for i in range(player.max_health - player.health):
			$UI/HealthBars.add_child(healthbar.instance())
	if Input.is_action_just_pressed("shoot"):
		started = true
		get_tree().paused = false
