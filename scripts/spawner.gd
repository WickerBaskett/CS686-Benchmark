extends Node3D

const QUAD := preload("res://scenes/basic_quad.tscn")
const OCCLUDED_QUAD := preload("res://scenes/occluded_quad.tscn")
var active_quad := QUAD

var start: bool = false;
var occluding: bool = false;

signal quad_spawned

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if start:
		start = false
		for i in 10000:
			var quad_inst = active_quad.instantiate()
			add_child(quad_inst)
			quad_inst.global_position = Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50))
			emit_signal("quad_spawned")

func _on_start_s_pawner_pressed() -> void:
	start = !start;

func _on_toggle_oc_pressed() -> void:
	if occluding:
		active_quad = QUAD
	else:
		active_quad = OCCLUDED_QUAD
	
	occluding = !occluding
