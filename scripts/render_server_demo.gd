extends Node3D

var mesh_array : Array
var inst_array : Array
@onready var quad = QuadMesh.new()
var start : bool = false

signal render_server_quad_spawned

func _process(_delta: float):
	if start:
		start = false
		for i in 10000:
			var instance = RenderingServer.instance_create()
			
			var scenario = get_world_3d().scenario
			RenderingServer.instance_set_scenario(instance, scenario)
			
			mesh_array.push_back(quad)
			RenderingServer.instance_set_base(instance, mesh_array.back())
			
			var xform = Transform3D(Basis(), Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
			RenderingServer.instance_set_transform(instance, xform)
			emit_signal("render_server_quad_spawned")

func _on_reload_pressed() -> void:
	print(mesh_array)
	mesh_array.clear()
	print(mesh_array)


func _on_start_render_server_quads_pressed() -> void:
		start = !start
