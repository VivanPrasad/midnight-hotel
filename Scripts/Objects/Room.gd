extends Node3D

var lights = true

var able = false
@onready var lever1 := $Switch/Lever1
@onready var lever2 := $Switch/Lever2
@onready var lamps := [$Light/OmniLight3D,$Light2/OmniLight3D]

func _ready():
	if get_index() != 0:
		$Clock.position.x = -2.4
	print($Light/OmniLight3D)
func _unhandled_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if able:
			if not $Switch/SFX.is_playing():
				$Switch/SFX.play()
				lights = !lights
				if lights:
					lever1.visible = false
					lever2.visible = true
					for light in lamps:
						light.visible = true
						light.get_child(0).play()
				else:
					lever2.visible = false
					lever1.visible = true
					for light in lamps:
						light.visible = false
						light.get_child(0).stop()

func _on_area_3d_area_entered(area):
	if area.name == "Select":
		%Note.visible = true
		able = true


func _on_area_3d_area_exited(area):
	if area.name == "Select":
		%Note.visible = false
		able = false

func _process(_delta):
	if get_index() == 0:
		if Game.hour == 1 and Game.minute < 10:
			lights = false
			if lights:
				lever1.visible = false
				lever2.visible = true
				for light in lamps:
					light.visible = true
					light.get_child(0).play()
			else:
				lever2.visible = false
				lever1.visible = true
				for light in lamps:
					light.visible = false
					light.get_child(0).stop()
		elif Game.hour == 3 and Game.minute < 3:
			lights = false
			if lights:
				lever1.visible = false
				lever2.visible = true
				for light in lamps:
					light.visible = true
					light.get_child(0).play()
			else:
				lever2.visible = false
				lever1.visible = true
				for light in lamps:
					light.visible = false
					light.get_child(0).stop()
	if Game.hour == 1 and Game.minute == 10:
		if Game.location == 1:
			get_tree().paused = true
			get_node("/root/World/HUD/Info").text = "You Died"
			get_node("/root/World/HUD/Info").visible = true
			get_node("/root/World/HUD/Black").visible = true
			queue_free()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_leave_body_entered(body):
	if body.name == "Player":
		Game.location = 0

func _on_enter_body_entered(body):
	if body.name == "Player":
		Game.location = 1
