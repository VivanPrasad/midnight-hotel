extends RigidDynamicBody3D

var destination : Vector3

var des = position
const SPEED = 4

var overlap = 0
var evil :bool = false
func set_destination(new_destination:Vector3):
	destination = new_destination
	$NavigationAgent3D.set_target_location(destination)

func _ready():
	if get_index() == 1:
		evil = true
	else:
		$Area3D.monitoring = false
		$Timer.wait_time = 1
		$Knife.visible = false
func _physics_process(_delta):
	for ray in $Eye.get_children():
		if ray.is_colliding() and ray.get_collider().name == "Player" and evil:
			set_destination(ray.get_collider().position)
		else:
			$Eye.rotation.y += 1
func _integrate_forces(_state):
	if $NavigationAgent3D.is_target_reachable() and not $NavigationAgent3D.is_target_reached():
		var target = $NavigationAgent3D.get_next_location()
		var velocity = global_position.direction_to(target).normalized() * SPEED
		$NavigationAgent3D.set_velocity(velocity)
		if not $Footstep.is_playing():
			$Footstep.play()
		$Knife.rotation.y = velocity.y
	else:
		set_linear_velocity(Vector3.ZERO)
		$Footstep.stop()

func _on_timer_timeout():
	if not $Footstep.is_playing():
		randomize()
		if randi() % 4 == 0:
			set_destination(Vector3(0,0,10))
		elif randi() % 4 == 1:
			set_destination(Vector3(0,4.9,10))
		elif randi() % 4 == 2:
			set_destination(Vector3(-55,0,10))
		elif randi() % 4 == 3:
			set_destination(Vector3(-27,4.9,10))
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		get_tree().paused = true
		get_node("/root/World/HUD/Info").text = "You Died"
		get_node("/root/World/HUD/Info").visible = true
		get_node("/root/World/HUD/Black").visible = true
		queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif body.name == "NPC":
		if overlap == 1:
			get_parent().get_child(body.get_index()).kill()
		else:
			pass

func kill():
	axis_lock_angular_z = false
	axis_lock_angular_y = false
	axis_lock_angular_x = false
	$MeshInstance3D.transparency = 0.5
	$CollisionShape3D.disabled = true
