extends Node3D

const MULTI_MESH = preload("res://scenes/multi_mesh.tscn")
var mult_mesh
var mult_is_child : bool = false
var debug_mode : bool = false
var paused : bool = false

func _ready() -> void:
	mult_mesh = MULTI_MESH.instantiate()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle"):
		if debug_mode:
			get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_DISABLED)
			debug_mode = false
		else:
			get_viewport().set_debug_draw(Viewport.DEBUG_DRAW_OVERDRAW)
			debug_mode = true
	elif event.is_action_pressed("menu_toggle"):
		if !paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			paused = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			paused = false
		
func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_start_mult_pressed() -> void:
	if not mult_is_child:
		add_child(mult_mesh)
	else:
		remove_child(mult_mesh)
	mult_is_child = !mult_is_child
