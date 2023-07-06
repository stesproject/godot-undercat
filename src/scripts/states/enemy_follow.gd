extends StateNode
class_name EnemyFollowState

@export var speed: = 50.0

var target: CharacterBody2D

func enter(params: Dictionary = {}):
	super.enter()
	for param in params.keys():
		self[param] = params[param]


func physics_update(delta):
	var direction = entity.global_position.direction_to(target.global_position)
	entity.move_direction = direction.normalized()
	entity.velocity = entity.move_direction * speed


func _on_detection_area_body_exited(body):
	transitioned.emit(self, "wander")


func _on_attack_area_body_entered(body):
	# Transit to attack state
	print(entity.name, " attack ", body.name)
