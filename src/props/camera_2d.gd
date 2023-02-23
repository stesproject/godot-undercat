extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	position_smoothing_enabled = true
