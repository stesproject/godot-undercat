extends Area2D
class_name Interactable

@export var action_name = ""
@export var constrain_direction = Vector2i.ZERO

var entity: CharacterEntity = null
var can_iteract = "":
	set(value):
		can_iteract = value
		if value != "":
			print(value, " can interact with: ", owner.name)

signal action_triggered(object)

func _on_body_entered(body):
	if body:
		can_iteract = body.name
		entity = body
		if Input.is_action_pressed(action_name):
			_try_to_trigger_action()


func _on_body_exited(body):
	can_iteract = ""
	entity = null


func _unhandled_input(event):
	if can_iteract != "" && action_name != "" && event.is_action_pressed(action_name):
		_try_to_trigger_action()


func _try_to_trigger_action():
	if _check_direction():
		action_triggered.emit(self)


func _check_direction():
	if entity && constrain_direction != Vector2i.ZERO:
		var invalid_direction = constrain_direction != Vector2i(entity.move_direction.x, entity.move_direction.y)
		return !invalid_direction
	return true
