extends Node

const speed = 70
var second = 0
var minute = 0
var hour = 0

var event = [3600]

var location = 1
func _process(delta):
	if hour < 5:
		second += int(floor(delta * speed))
		@warning_ignore(integer_division)
		minute = int(second / 60) % 60
		@warning_ignore(integer_division)
		hour = int(second / (3600))
	else:
		second = 0
		minute = 0
		hour = 5
		get_node("/root/World/HUD/Info").visible = true
		get_node("/root/World/HUD/Black").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func _ready():
	randomize()
	event[0] += randi() % 3500
