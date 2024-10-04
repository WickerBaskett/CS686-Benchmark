extends Label

var quads : int
var last_60_fps : int
var mult_visible : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	
	# Update the UI element
	text = "FPS: " + str(fps) \
	+ "\nDelta: " + str(delta) \
	+ "\nQuads: " + str(quads)


func _on_node_3d_render_server_quad_spawned() -> void:
	quads += 1


func _on_start_mult_pressed() -> void:
	if !mult_visible:
		quads += 3000000
	else:
		quads -= 3000000
	mult_visible = !mult_visible

func _on_quad_spawner_quad_spawned() -> void:
	quads += 1
