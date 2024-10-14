extends Node3D

@export var oc_scale: float = 2.5

@onready var quad = QuadMesh.new()
var mesh_array: Array
var occluder_array: Array
var instance_array: Array

var start: bool = false

signal render_server_quad_spawned

func _process(_delta: float):
	if start:
		start = false
		for i in 10000:
			
			# Get a random position for the current mesh
			var pos = Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50))
			
			# Create an array of the vertexes of a square mesh at
			# the location randomized position, this is passed as a one 
			# dimensional array
			var vert_array: Array
			# Top Left       | Index 0
			vert_array.push_back(int(pos.x + 1))
			vert_array.push_back(int(pos.y + 1.0))
			vert_array.push_back(int(pos.z))
			# Bottom Left    | Index 1
			vert_array.push_back(int(pos.x + 1.0))
			vert_array.push_back(int(pos.y - 1.0))
			vert_array.push_back(int(pos.z))
			# Bottom Right   | Index 2
			vert_array.push_back(int(pos.x - 1.0))
			vert_array.push_back(int(pos.y - 1.0))
			vert_array.push_back(int(pos.z))
			# Top Right      | Index 3
			vert_array.push_back(float(pos.x - 1))
			vert_array.push_back(float(pos.y + 1))
			vert_array.push_back(float(pos.z))
			
			# Set up the vertex and index buffer
			var vertices := PackedVector3Array(vert_array)
			var indices := PackedInt32Array([0,1,2,0,2,3])
			
			#################################################
			# Create a mesh and add it to the Render Server #
			#################################################
			
			# Create a render server instance
			var mesh_instance := RenderingServer.instance_create()
			
			# Store instance RID to free later
			instance_array.push_back(mesh_instance)
			
			# Get the scenario this node is in
			var scenario := get_world_3d().scenario
			RenderingServer.instance_set_scenario(mesh_instance, scenario)
			
			# Set the vertex format flag, feels like there should be a better
			# way to find the right format bytes than digging through the source code
			# 0x1 << 0x0 represents a Vertex Buffer
			var format = 0x1 << 0x0
			
			var mesh_surface: Dictionary = {}
			# We are drawing our shape using triangles
			mesh_surface.get_or_add("primitive", RenderingServer.PRIMITIVE_TRIANGLES)
			# 
			mesh_surface.get_or_add("format", format)
			# The vertex and index buffers to be drawn
			mesh_surface.get_or_add("vertex_data", vertices)
			mesh_surface.get_or_add("vertex_count", vertices.size())
			mesh_surface.get_or_add("index_data", indices)
			mesh_surface.get_or_add("index_count", indices.size())
			# The axis aligned bounding box for our mesh
			mesh_surface.get_or_add("aabb", AABB(pos, Vector3(2, 2, 0.5)))
			
			# Add mesh to the viewport scenario
			var mesh = RenderingServer.mesh_create()
			RenderingServer.mesh_add_surface(mesh, mesh_surface)
			mesh_array.push_back(mesh)
			
			RenderingServer.instance_set_base(mesh_instance, mesh_array.back())
			
			# Adjust the transform of the mesh 
			var xform := Transform3D(Basis(), pos)
			RenderingServer.instance_set_transform(mesh_instance, xform)
			
			###################################
			# Create an Occluder for the mesh #
			###################################
			
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
	mesh_array.clear()
	instance_array.clear()
	occluder_array.clear()


func _on_start_render_server_quads_pressed() -> void:
	start = !start
