extends Node3D

var selected = false
var open = false
func _unhandled_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not $AnimationPlayer.is_playing():
		if selected:
			if Game.hour == 1 and Game.minute < 15:
				pass
			else:
				open = !open
				if open:
					$AnimationPlayer.play("Close")
				else:
					$AnimationPlayer.play("Open")
			
func _on_area_3d_area_entered(_area):
	if get_index() == 0:
		%Note.visible = true
		selected = true
func _on_area_3d_area_exited(_area):
	selected = false
	%Note.visible = false

func _on_timer_timeout():
	if get_index() == 0:
		randomize()
		$Timer.wait_time = float(randi() % 100)
		open = !open
		if open:
			$AnimationPlayer.play("Close")
		else:
			$AnimationPlayer.play("Open")


func _on_area_3_d_2_body_entered(body):
	if body.name == "NPC":
		open = !open
		if open:
			$AnimationPlayer.play("Close")
		else:
			$AnimationPlayer.play("Open")
