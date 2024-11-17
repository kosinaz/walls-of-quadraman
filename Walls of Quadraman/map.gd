extends Node

var tween = null
var map_position = Vector3(0, 0, 0)
var up_is_down = false
var left_is_down = false
var right_is_down = false
var down_is_down = false
var config = ConfigFile.new()

func _ready():
	# warning-ignore:unused_variable
	var result = config.load("user://config.cfg")
	config.set_value("progress", "lesson", 0)
	config.save("user://config.cfg")

func _process(_delta):
	if tween != null and tween.is_running():
		return
	if Input.is_action_pressed("ui_left") or left_is_down:
		map_position.x -= 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 270
	elif Input.is_action_pressed("ui_right") or right_is_down:
		map_position.x += 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 90
	elif Input.is_action_pressed("ui_up") or up_is_down:
		map_position.z -= 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 180
	elif Input.is_action_pressed("ui_down") or down_is_down:
		map_position.z += 1
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("sprint")
		$"%Player".rotation_degrees.y = 0
	else:
		$"%Player/Spatial/character-male-b/AnimationPlayer".play("idle")
		return
	tween = get_tree().create_tween()
	tween.tween_property($"%Player", "translation", map_position, 0.25)

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
