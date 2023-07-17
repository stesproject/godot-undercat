extends Node2D
class_name StateManager

@export var state: int = 0: set = _set_state

var cycle: int = 0: set = _set_cycle
var previous_state: int = 0
var state_data: StateData: set = _set_state_data

@onready var parent_name = get_parent().name

signal state_changed(value)
signal cycle_updated(value)


func _ready():
	if !is_in_group("state"):
		state = state


func _set_state(value):
	print(parent_name, " state changed to: ", state)
	_update_cycle()
	previous_state = state
	state = value
	state_changed.emit(state)


func _set_cycle(value):
#	print_debug(parent_name, " cycle updated to: ", cycle)
	cycle = value
	cycle_updated.emit(cycle)


func _set_state_data(value):
	state_data = value
	state = state_data.state


func _update_cycle():
	if state == 0:
		cycle += 1
