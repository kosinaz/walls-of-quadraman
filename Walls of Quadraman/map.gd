extends Node

var tween = null
var up_is_down = false
var left_is_down = false
var right_is_down = false
var down_is_down = false
var config = ConfigFile.new()
onready var player_translation = $"%Player".translation
onready var ram_translation = $"%Ram".translation

func _ready():
	# warning-ignore:unused_variable
	var result = config.load("user://config.cfg")
	config.set_value("progress", "lesson", 0)
	config.save("user://config.cfg")

func _process(_delta):
	if tween != null and tween.is_running():
		return
	if Input.is_action_pressed("ui_left") or left_is_down:
		if _is_wall(player_translation - Vector3(1, 0, 0)):
			return
		if _get_door(player_translation - Vector3(1, 0, 0)):
			return
		if ram_translation == player_translation - Vector3(1, 0, 0):
			if _is_wall(ram_translation - Vector3(1, 0, 0)):
				return
			var door = _get_door(ram_translation - Vector3(1, 0, 0))
			if door: 
				door.queue_free()
			ram_translation.x -= 1
			$"%Ram".rotation_degrees.y = 180
		player_translation.x -= 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 270
	elif Input.is_action_pressed("ui_right") or right_is_down:
		if _is_wall(player_translation + Vector3(1, 0, 0)):
			return
		if _get_door(player_translation + Vector3(1, 0, 0)):
			return
		if ram_translation == player_translation + Vector3(1, 0, 0):
			if _is_wall(ram_translation + Vector3(1, 0, 0)):
				return
			var door = _get_door(ram_translation + Vector3(1, 0, 0))
			if door: 
				door.queue_free()
			ram_translation.x += 1
			$"%Ram".rotation_degrees.y = 0
		player_translation.x += 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 90
	elif Input.is_action_pressed("ui_up") or up_is_down:
		if _is_wall(player_translation - Vector3(0, 0, 1)):
			return
		if _get_door(player_translation - Vector3(0, 0, 1)):
			return
		if ram_translation == player_translation - Vector3(0, 0, 1):
			if _is_wall(ram_translation - Vector3(0, 0, 1)):
				return
			var door = _get_door(ram_translation - Vector3(0, 0, 1))
			if door: 
				door.queue_free()
			ram_translation.z -= 1
			$"%Ram".rotation_degrees.y = 90
		player_translation.z -= 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 180
	elif Input.is_action_pressed("ui_down") or down_is_down:
		if _is_wall(player_translation + Vector3(0, 0, 1)):
			return
		if _get_door(player_translation + Vector3(0, 0, 1)):
			return
		if ram_translation == player_translation + Vector3(0, 0, 1):
			if _is_wall(ram_translation + Vector3(0, 0, 1)):
				return
			var door = _get_door(ram_translation + Vector3(0, 0, 1))
			if door: 
				door.queue_free()
			ram_translation.z += 1
			$"%Ram".rotation_degrees.y = 270
		player_translation.z += 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 0
	else:
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("idle")
		return
	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($"%Player", "translation", player_translation, 0.25)
	tween.tween_property($"%Ram", "translation", ram_translation, 0.25)

func _is_wall(translation):
	for wall in get_tree().get_nodes_in_group("walls"):
		if wall.translation == translation:
			return true
	return false

func _get_door(translation):
	for door in get_tree().get_nodes_in_group("doors"):
		if door.translation == translation:
			return door
	return null

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
