extends Node

var up_is_down = false
var left_is_down = false
var right_is_down = false
var down_is_down = false
var config = ConfigFile.new()
onready var player_translation = $"%Player".translation

func _ready():
	# warning-ignore:unused_variable
	var result = config.load("user://config.cfg")
	config.set_value("progress", "lesson", 0)
	config.save("user://config.cfg")

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
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
