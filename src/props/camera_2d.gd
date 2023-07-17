extends Camera2D

## Set -1 to disable
@export var enable_smoothing_after = 0.2
@export var targetNode: Node2D = null: set = _set_target


# Called when the node enters the scene tree for the first time.
func _ready():
	if enable_smoothing_after != -1:
		await get_tree().create_timer(enable_smoothing_after).timeout
		position_smoothing_enabled = true


func _process(delta):
	if targetNode != null:
		position = targetNode.global_position


func _set_target(value):
	targetNode = value
	if targetNode == null:
		print("Target node '", value.name, "' not found!")
		set_process(false)
	else:
		print("Camera following node '", targetNode.name, "'.")
		set_process(true)
