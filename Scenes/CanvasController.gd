extends CanvasLayer
enum STATES {TITLE, GAME, END}
var state = STATES.TITLE
var fadeMod = 1
var labelMod = 0
var uiMod = 0
var player
var healthbar = preload("res://Objects/HealthBox.tscn")
var healthbehind = preload("res://Objects/HealthBehind.tscn")
var bullet_selected = 0
var time_alive = 0
func _ready():
	player = get_parent().get_node("Player")
	$ColorRect.visible = true
func _process(delta):
	if state == STATES.TITLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.modulate = Color(1, 1, 1, 1)
		get_tree().paused = true
		if fadeMod > 0.1:
			fadeMod -= delta
		else:
			if (labelMod<1): labelMod += delta/2
		if Input.is_action_just_pressed("shoot"):
			state = STATES.GAME
			get_tree().paused = false
	elif state == STATES.GAME:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		get_tree().paused = false
		if (labelMod>0): labelMod -= delta
		if (uiMod<1): uiMod += delta
		fadeMod = 0
		time_alive += delta
		var domucount = 0
		for domu in get_parent().get_node("Domus").get_children():
			if domu.activated:
				domucount += 1
		$UI/DomuCount.text = "x"+str(domucount)
		$UI/CoinCount.text = "x"+str(player.money)
		if $UI/HealthBars.get_child_count() != (player.max_health - player.health):
			for child in $UI/HealthBars.get_children():
				$UI/HealthBars.remove_child(child)
			for i in range(player.max_health - player.health):
				$UI/HealthBars.add_child(healthbar.instance())
		if $UI/HealthBehinds.get_child_count() != player.max_health:
			for child in $UI/HealthBehinds.get_children():
				$UI/HealthBehinds.remove_child(child)
			for i in range(player.max_health):
				$UI/HealthBehinds.add_child(healthbehind.instance())
		$UI/Selector.rect_position.x = 392 + bullet_selected*64
		if Input.is_action_just_released("ui_right"):
			bullet_selected += 1
			if bullet_selected > 3: bullet_selected = 0
		while player.bulletAmounts[bullet_selected] == 0:
			bullet_selected += 1
			if bullet_selected > 3: bullet_selected = 0
		if Input.is_action_just_released("ui_left"):
			bullet_selected -= 1
			if bullet_selected < 0: bullet_selected = 3
			while player.bulletAmounts[bullet_selected] == 0:
				bullet_selected -= 1
				if bullet_selected < 0: bullet_selected = 3
		player.bullet_selected = bullet_selected
		if player.bulletAmounts[1] > 0:
			$UI/BulletBar/TextureRect2/Bullet.visible = true
			$UI/BulletBar/TextureRect2/Label.text = "x"+str(player.bulletAmounts[1])
		else:
			$UI/BulletBar/TextureRect2/Bullet.visible = false
			$UI/BulletBar/TextureRect2/Label.text = ""
		if player.bulletAmounts[2] > 0:
			$UI/BulletBar/TextureRect3/Bullet.visible = true
			$UI/BulletBar/TextureRect3/Label.text = "x"+str(player.bulletAmounts[2])
		else:
			$UI/BulletBar/TextureRect3/Bullet.visible = false
			$UI/BulletBar/TextureRect3/Label.text = ""
		if player.bulletAmounts[3] > 0:
			$UI/BulletBar/TextureRect4/Bullet.visible = true
			$UI/BulletBar/TextureRect4/Label.text = "x"+str(player.bulletAmounts[3])
		else:
			$UI/BulletBar/TextureRect4/Bullet.visible = false
			$UI/BulletBar/TextureRect4/Label.text = ""
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		for child in $UI/HealthBars.get_children():
			$UI/HealthBars.remove_child(child)
		if fadeMod < 1:
			fadeMod += delta
		$ColorRect/Control.visible = true
		$ColorRect/Control/Label2.text = "Your Time:"+str(int(time_alive))
		if Input.is_action_just_pressed("shoot"):
			get_tree().reload_current_scene()
	$Label.modulate = Color(1, 1, 1, labelMod)
	$ColorRect.modulate = Color(1, 1, 1, fadeMod)
	$UI.modulate = Color(1, 1, 1, uiMod)
func _on_Player_end():
	state = STATES.END
