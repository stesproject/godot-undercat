extends StateNode


func _ready():
	super._ready()
	await owner.ready
	entity.detection_area.connect("body_entered", _on_body_detected)


func _on_body_detected(body):
	change_state(next_state, {
		"target": body
	})


func enter(params: Dictionary = {}):
	super.enter()
	entity.velocity = Vector2.ZERO
	
