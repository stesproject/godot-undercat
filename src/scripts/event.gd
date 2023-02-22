extends Node2D
class_name Event

@export var actions: Array[Action] = []

@onready var state_manager: StateManager = get_parent()
@onready var index = get_index()

var ca = null # current action
var node_ref = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if state_manager:
		state_manager.connect("state_changed", on_state_changed)


func on_state_changed(value):
	if index == value:
		for action in actions:
			ca = action
			await run_action()


func run_action():
	if ca.enabled:
		node_ref = get_node(ca.node_ref) if ca.node_ref else null
		await await_signal()
		match ca.action:
			"set_swap_players":
				action_set_swap_players()
			"await_timer":
				await action_await_timer()
			"next":
				state_manager.state += 1
			_:
				action_default()


func action_default():
	var value = load(ca.value) if ca.value.contains("res://") else ca.value
	var node = get_node_or_null(ca.value)
	node_ref[ca.action] = node if node else value


func action_set_swap_players():
	SwapPlayers.can_swap = ca.value


func action_await_timer():
	var seconds = float(ca.value)
	await get_tree().create_timer(seconds).timeout


func await_signal():
	await node_ref[ca.await_signal] if node_ref && ca.await_signal else null
