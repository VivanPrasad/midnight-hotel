extends CharacterBody3D


const SPEED = 3.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

	
func _physics_process(delta):
	#get_parent().get_child(1).set_destination(global_position)
	#print(global_position.distance_to($"../NPC".global_position))
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if direction and is_on_floor():
		if not $Footstep.is_playing():
			randomize()
			if randi() % 100 > 50:
				if $Footstep.pitch_scale < 1.03:
					$Footstep.pitch_scale += 0.01
			else:
				if $Footstep.pitch_scale > 0.93:
					$Footstep.pitch_scale -= 0.01
			$Footstep.play()
			
	else:
		if $Footstep.is_playing():
			$Footstep.stop()
	move_and_slide()

func _process(_delta):
	if Game.hour == 0 and Game.minute == 59:
		$Ghost.play()
		$Heartbeat.play()
	if Game.hour == 3 and Game.minute == 0:
		$Ghost.play()
		$Heartbeat.play()
	if Game.minute > 15 and Game.hour in [1,3]:
		$Heartbeat.stop()

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().quit()
	if event.is_action_released("fullscreen"):
		if DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			$Neck/Select.rotation = camera.rotation
			$Cards.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg2rad(-70), deg2rad(70))
func _input(_event):
	if Input.is_action_just_pressed("cards"):
		$Cards/Check.play()
		if $Cards/Card/Label3D.visible:
			$Cards/Card/Label3D.visible = false
	if Input.is_action_pressed("cards"):
		$Cards.visible = false
	else:
		$Cards.visible = true
