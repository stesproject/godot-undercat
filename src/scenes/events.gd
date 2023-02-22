extends Node2D

@export var is_active = false:
	set(value):
		is_active = value
		next_action()
@export var actions: Array[Resource] = []

var index = 0
var current_action: Action = null
var entity: Entity = null


# Called when the node enters the scene tree for the first time.
func _ready():
	return
	if is_active:
		next_action()


func next_action():
	if index == actions.size():
		set_process(false)
		return
		
	current_action = actions[index]
	if current_action.enabled:
		entity = get_node(current_action.entity)
		match current_action.action:
			"set_target":
				await action_set_target()
			_:
				await action_default()

	index += 1
	next_action()


func action_default():
	var value = current_action.value
	entity[current_action.action] = load(value) if value.contains("res://") else value


func action_set_target():
	entity.target = get_node(current_action.value)
	await entity[current_action.wait_for]
