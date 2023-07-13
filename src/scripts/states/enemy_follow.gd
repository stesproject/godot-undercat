extends StateNode

@export var speed: = 50.0

var target: CharacterBody2D


func _ready():
	super._ready()
	await owner.ready
	entity.detection_area.connect("body_exited", _on_body_away)
	entity.attack_area.connect("body_entered", _on_body_nearby)

func enter(params: Dictionary = {}):
	super.enter()
	for param in params.keys():
		self[param] = params[param]


func physics_update(delta):
	var direction = entity.global_position.direction_to(target.global_position)
	entity.move_direction = direction.normalized()
	entity.velocity = entity.move_direction * speed


func _on_body_away(body):
	change_state(state_machine.previous_state)


func _on_body_nearby(body):
	# Transit to attack state
	print(entity.name, " attack ", body.name)
	if body is PlayerEntity:
		body.hp -= entity.attack_power
