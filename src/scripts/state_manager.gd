extends Node2D
class_name StateManager

@onready var parent_name = get_parent().name

signal state_changed(value)
signal cycle_updated(value)

var cycle: int = 0:
	set(value):
		cycle = value
		cycle_updated.emit(cycle)
#		print_debug(parent_name, " cycle updated to: ", cycle)
var previous_state: int = 0
@export var state: int = 0:
	set(value):
		update_cycle()
		previous_state = state
		state = value
		state_changed.emit(state)
		print(parent_name, " state changed to: ", state)

var state_data: StateData:
	set(value):
		state_data = value
		state = state_data.state


#func _ready():
#	state = state


func update_cycle():
	if state == 0:
		cycle += 1
