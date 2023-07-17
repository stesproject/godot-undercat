extends Node
class_name StateMachine

@export var initial_state: StateNode

var states: Dictionary = {}
var previous_state: StateNode
var current_state: StateNode:
	set(value):
		previous_state = current_state
		current_state = value
		print(owner.name, " state changed to: ", current_state.name)


func _ready():
	for child in get_children():
		if child is StateNode:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
	
	await owner.ready
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.update(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func on_state_transition(state, new_state_name, params: Dictionary = {}):
	if state != current_state:
		return
	
	var new_state: StateNode = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
		
	new_state.enter(params)
	
	current_state = new_state
