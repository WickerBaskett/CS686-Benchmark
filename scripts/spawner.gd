extends Node3D

const QUAD = preload("res://scenes/quad.tscn")
var last_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var offset : Vector3 = Vector3(0.3, 0.0, 0.0)
var start : bool = false;

signal quad_spawned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if start:
		for i in 1000:
			var quad_inst = QUAD.instantiate()
			add_child(quad_inst)
			quad_inst.global_position = Vector3(randf_range(-50, 50), randf_range(-50, 50), 0.0)
			
		emit_signal("quad_spawned")


func _on_starts_pressed() -> void:
	start = true;
