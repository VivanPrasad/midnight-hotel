extends Node3D

@onready var display := $MeshInstance3D/MeshInstance3D/Label3D
func _process(_delta):
	if Game.hour < 2:
		if Game.minute < 10:
			display.text = str(Game.hour + 11) + ":0" + str(Game.minute)
		else:
			display.text = str(Game.hour + 11) + ":" + str(Game.minute)
	else:
		if Game.minute < 10:
			display.text = " " +str(Game.hour -1) + ":0" + str(Game.minute)
		else:
			display.text = " " + str(Game.hour -1) + ":" + str(Game.minute)
