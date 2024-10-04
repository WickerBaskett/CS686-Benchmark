extends MultiMeshInstance3D

@onready var quad = QuadMesh.new()

var running : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = 3000000
	multimesh.visible_instance_count = 3000000
	multimesh.mesh = quad
	for i in multimesh.visible_instance_count:
		multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50))))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_mult_pressed() -> void:
	multimesh.visible_instance_count = -1
