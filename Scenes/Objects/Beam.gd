extends Node3D



func _on_area_3d_area_entered(_area):
	$OmniLight3D.visible = false


func _on_area_3d_area_exited(_area):
	$OmniLight3D.visible = true
