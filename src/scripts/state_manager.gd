extends Node2D
class_name StateManager

@export var initial_state = 0

signal state_changed(value)
signal cycle_updated(value)

var cycle: int = 0:
	set(value):
		cycle = value
		cycle_updated.emit(cycle)
		print_debug(get_path(), " cycle updated to: ", cycle)
var previous_state: int = 0
var state: int = 0:
	set(value):
		update_cycle()
		previous_state = state
		state = value
		state_changed.emit(state)
		print_debug(get_path(), " state changed to: ", state)

var state_data: StateData:
	set(value):
		state_data = value
		state = state_data.state


# Called when the node enters the scene tree for the first time.
func _ready():
	set_events_id()
	state = initial_state


func set_events_id():
	var children = get_children()
	for i in children.size():
		children[i].index = i


func update_cycle():
	if state == 0:
		cycle += 1
