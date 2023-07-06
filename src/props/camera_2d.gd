extends Camera2D

# Set -1 to disable
@export var enable_smoothing_after = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	if enable_smoothing_after != -1:
		await get_tree().create_timer(enable_smoothing_after).timeout
		position_smoothing_enabled = true
