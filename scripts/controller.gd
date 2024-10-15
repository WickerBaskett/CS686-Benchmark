extends Node3D

const MULTI_MESH := preload("res://scenes/multi_mesh.tscn")
var mult_mesh: Node
var mult_is_child : bool = false
var paused : bool = false

func _ready() -> void:
	mult_mesh = MULTI_MESH.instantiate()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	# Toggle between different viewports
	if event.is_action_pressed("debug_default"):
		get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_DISABLED)
	elif event.is_action_pressed("debug_overdraw"):
		get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_OVERDRAW)
	elif event.is_action_pressed("debug_occluder"):
		get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_OCCLUDERS)
	elif event.is_action_pressed("debug_normal"):
		get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_NORMAL_BUFFER)
	
	# Toggle between rotating camera and interacting with UI
	elif event.is_action_pressed("menu_toggle"):
		if !paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			paused = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			paused = false

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

# Add and remove the multimesh from the scene
func _on_start_mult_pressed() -> void:
	if not mult_is_child:
		add_child(mult_mesh)
	else:
		remove_child(mult_mesh)
	mult_is_child = !mult_is_child
