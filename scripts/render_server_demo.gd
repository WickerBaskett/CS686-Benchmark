extends Node3D

@export var oc_scale: float = 2.5

var mesh_array: Array
@onready var quad = QuadMesh.new()

var occluder_array: Array
var start: bool = false

signal render_server_quad_spawned

func _process(_delta: float):
	if start:
		start = false
		for i in 10000:
			# Create a render server instance
			var instance := RenderingServer.instance_create()
			
			# Get the scenario this node is in
			var scenario := get_world_3d().scenario
			RenderingServer.instance_set_scenario(instance, scenario)
			
			# Add mesh to the viewport scenario
			mesh_array.push_back(quad)
			RenderingServer.instance_set_base(instance, mesh_array.back())
			
			# Get a random position for the current mesh
			var pos = Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50))
			
			# Adjust the transform of the mesh 
			var xform := Transform3D(Basis(), pos)
			RenderingServer.instance_set_transform(instance, xform)
			
			# Create an array of the vertexes of a square occluder mesh at
			# the location of the current mesh
			var vert_array: Array
			# Top Left
			vert_array.push_back(Vector3((pos.x + 1) * oc_scale, (pos.y + 1) * oc_scale, pos.z))
			# Bottom Left
			vert_array.push_back(Vector3((pos.x + 1) * oc_scale, (pos.y - 1) * oc_scale, pos.z))
			# Bottom Right
			vert_array.push_back(Vector3((pos.x - 1) * oc_scale, (pos.y - 1) * oc_scale, pos.z))
			# Top Right
			vert_array.push_back(Vector3((pos.x - 1) * oc_scale, (pos.y + 1) * oc_scale, pos.z))
			
			# 
			var vertices := PackedVector3Array(vert_array)
			var indices := PackedInt32Array([0,1,2,0,2,3])
			
			occluder_array.push_back(RenderingServer.occluder_create())
			RenderingServer.occluder_set_mesh(occluder_array.back(), vertices, indices)
			
			emit_signal("render_server_quad_spawned")

func _on_reload_pressed() -> void:
	mesh_array.clear()


func _on_start_render_server_quads_pressed() -> void:
		start = !start
