extends Area2D

@export var action_name = ""

var can_iteract = false

signal action_triggered(object)

func _on_body_entered(body):
	can_iteract = true


func _on_body_exited(body):
	can_iteract = false


func _unhandled_input(event):
	if can_iteract && action_name != "" && event.is_action_pressed(action_name):
		action_triggered.emit(self)
		
