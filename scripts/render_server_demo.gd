extends Node3D

@export var oc_scale: float = 2.5

@onready var quad = QuadMesh.new()
var mesh_array: Array
var occluder_array: Array
var instance_array: Array

var occluding: bool = false
var start: bool = false

signal render_server_quad_spawned

func _process(_delta: float):
	if start:
		start = false
		for i in 10000:
			
			# Get a random position for the current mesh
			var pos = Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50))
			
			#################################################
			# Create a mesh and add it to the Render Server #
			#################################################
			
			# Create a render server instance
			var mesh_instance := RenderingServer.instance_create()
			instance_array.push_back(mesh_instance)
			
			# Get the scenario this node is in
			var scenario := get_world_3d().scenario
			RenderingServer.instance_set_scenario(mesh_instance, scenario)
			
			# Add mesh to the viewport scenario
			mesh_array.push_back(quad)
			RenderingServer.instance_set_base(mesh_instance, mesh_array.back())

			# Adjust the transform of the mesh 
			var xform := Transform3D(Basis(), pos)
			RenderingServer.instance_set_transform(mesh_instance, xform)
			
			###################################
			# Create an Occluder for the mesh #
			###################################
			if occluding:
				# Create an array of the vertexes of a square mesh at pos
				var vert_array: Array
				# Top Right       | Index 0
				vert_array.push_back(Vector3((pos.x + oc_scale), (pos.y + oc_scale), pos.z))
				# Bottom Right    | Index 1
				vert_array.push_back(Vector3((pos.x + oc_scale), (pos.y - oc_scale), pos.z))
				# Bottom Left     | Index 2
				vert_array.push_back(Vector3((pos.x - oc_scale), (pos.y - oc_scale), pos.z))
				# Top Left        | Index 3
				vert_array.push_back(Vector3((pos.x - oc_scale), (pos.y + oc_scale), pos.z))
				
				# Set up the vertex and index buffer
				var vertices := PackedVector3Array(vert_array)
				var indices := PackedInt32Array([0,1,2,0,2,3])
				
				# Create the occluder with proper above dimensions
				occluder_array.push_back(RenderingServer.occluder_create())
				RenderingServer.occluder_set_mesh(occluder_array.back(), vertices, indices)
				
				# Create an instance and set the base the new occluder and the scenario to the world_3d
				var oc_instance = RenderingServer.instance_create2(occluder_array.back(), scenario)
				
				# Store instance array to free later
				instance_array.push_back(oc_instance)
			
			emit_signal("render_server_quad_spawned")

# Free all RIDs on reload
func _on_reload_pressed() -> void:
	# Free RIDs on RenderingServer
#	for mesh_rid in mesh_array:
#		RenderingServer.free_rid(mesh_rid)
#	for instance_rid in instance_array:
#		RenderingServer.free_rid(instance_rid)
#	for occluder_rid in occluder_array:
#		RenderingServer.free_rid(occluder_rid)
	
	# The RIDs we have stored no longer mean anything
	#   so we discard them
	mesh_array.clear()
	instance_array.clear()
	occluder_array.clear()


func _on_start_render_server_quads_pressed() -> void:
	start = !start


func _on_toggle_oc_pressed() -> void:
	occluding = !occluding
