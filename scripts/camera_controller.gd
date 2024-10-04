extends Camera3D

@export var look_speed := 300.0
@export var move_speed := 50.0

var paused: bool = false

func _process(delta: float) -> void:
	# Get horizontal direction of movement and convert to local coords
	var h_input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var h_dir := (transform.basis * Vector3(h_input_dir.x, 0, h_input_dir.y)).normalized()
	
	# Gets vertical direction of movement, left in global coords
	var v_direction := Input.get_axis("move_down", "move_up")
	
	# Adjust the position of the camera based on the input
	transform.origin += (Vector3(0, v_direction, 0) + h_dir) * delta * move_speed

func _input(event: InputEvent) -> void:
	# Handles looking around with the camera
	if event is InputEventMouseMotion and !paused:
		# Get the change in mouse position from last frame
		var look_dir = event.relative
		print(look_dir)
		
		# Project local z axis onto the gloabl x, y plane
		var plane_normal := Vector3(0, 1, 0)
		var z_axis := transform.basis.z
		var z_on_n := (z_axis.dot(plane_normal) / plane_normal.dot(plane_normal)) * plane_normal
		var new_z := z_axis - z_on_n
		
		# Nudge the x and y axes to based on mouse movement
		transform.basis.y += (new_z * (-look_dir.y / look_speed))
		transform.basis.x += (new_z  * (look_dir.x / look_speed))
		
		transform.basis = transform.basis.orthonormalized()
	elif event.is_action_pressed("menu_toggle"):
		paused = !paused
	
