extends Node

var up_is_down = false
var left_is_down = false
var right_is_down = false
var down_is_down = false
var config = ConfigFile.new()
var steps = []

func _ready():
	# warning-ignore:unused_variable
	var result = config.load("user://config.cfg")
	config.set_value("progress", "lesson", 0)
	config.save("user://config.cfg")

func _process(_delta):
	if $"%Player".translation.z < -4 and name.right(3) != "4":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://map" + str(int(name.right(3)) + 1) + ".tscn")
	if Input.is_action_pressed("restart"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_left") or left_is_down:
		$"%Player".move_towards(Vector3(-1, 0, 0))
		return
	if Input.is_action_pressed("ui_right") or right_is_down:
		$"%Player".move_towards(Vector3(1, 0, 0))
		return
	if Input.is_action_pressed("ui_up") or up_is_down:
		$"%Player".move_towards(Vector3(0, 0, -1))
		return
	if Input.is_action_pressed("ui_down") or down_is_down:
		$"%Player".move_towards(Vector3(0, 0, 1))
		return
	if Input.is_action_just_released("undo"):
		_pop_back_step()
		return

func _append_step():
	var step = {
		"siege_towers": [],
		"rams": [],
		"doors": [],
		"player_translation": $"%Player".translation
	}
	for siege_tower in get_tree().get_nodes_in_group("siege_towers"):
		step.siege_towers.append({
			"node": siege_tower,
			"translation": siege_tower.translation,
		})
	for ram in get_tree().get_nodes_in_group("rams"):
		step.rams.append({
			"node": ram,
			"translation": ram.translation,
		})
	for door in get_tree().get_nodes_in_group("doors"):
		step.doors.append({
			"node": door,
			"visible": door.visible,
		})
	steps.append(step)

func _pop_back_step():
	var step = steps.pop_back()
	if not step:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		return
	if $"%Player".translation == step.player_translation:
		step = steps.pop_back()
	if not step:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		return
	$"%Player".translation = step.player_translation
	for siege_tower in step.siege_towers:
		siege_tower.node.translation = siege_tower.translation
	for ram in step.rams:
		ram.node.translation = ram.translation
	for door in step.doors:
		door.node.visible = door.visible

func _on_up_button_down():
	up_is_down = true

func _on_left_button_down():
	left_is_down = true

func _on_down_button_down():
	down_is_down = true

func _on_right_button_down():
	right_is_down = true

func _on_up_button_up():
	up_is_down = false

func _on_left_button_up():
	left_is_down = false

func _on_down_button_up():
	down_is_down = false

func _on_right_button_up():
	right_is_down = false

func _on_player_moved():
	_append_step()
