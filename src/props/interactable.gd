extends Area2D

@export var action_name = ""

var can_iteract = "":
	set(value):
		can_iteract = value
		if value != "":
			print(value, " can interact with: ", name)

signal action_triggered(object)

func _on_body_entered(body):
	can_iteract = body.name


func _on_body_exited(body):
	can_iteract = ""


func _unhandled_input(event):
	if can_iteract != "" && action_name != "" && event.is_action_pressed(action_name):
		action_triggered.emit(self)
		
