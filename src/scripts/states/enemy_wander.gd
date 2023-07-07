extends StateNode

@export var speed: = 50.0
@export var wander_time_range: = Vector2.ZERO

var wander_time: float


func _ready():
	super._ready()
	await owner.ready
	entity.detection_area.connect("body_entered", _on_body_detected)


func randomize_wander():
	entity.move_direction = Vector2(randf_range(-1, 1), randf_range(-1 , 1)).normalized()
	wander_time = randf_range(wander_time_range.x, wander_time_range.y)


func enter(params: Dictionary = {}):
	super.enter()
	randomize_wander()


func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func physics_update(delta: float):
	entity.velocity = entity.move_direction * speed


func _on_body_detected(body):
	change_state(next_state, {
		"target": body
	})
