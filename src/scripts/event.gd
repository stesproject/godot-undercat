extends Node2D
class_name Event

@export var dialogue_resource: DialogueResource
@export var actions: Array[Action] = []

@onready var _state_manager: StateManager = get_parent()
@onready var _index = get_index()

const Balloon = preload("res://src/dialogues/portraits_balloon/balloon.tscn")

var ca = null # current action
var node_ref = null
var dialogue_title = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if _state_manager:
		_state_manager.connect("state_changed", on_state_changed)
	if dialogue_resource:
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished)


func on_state_changed(value):
	if _index == value:
		for action in actions:
			ca = action
			await _run_action()


func _run_action():
	if ca.enabled:
		node_ref = get_node(ca.node_ref) if ca.node_ref else null
		await _await_signal()
		match ca.action:
			"set_swap_players":
				_action_set_swap_players()
			"await_timer":
				await _action_await_timer()
			"next":
				_state_manager.state += int(ca.value) if ca.value else 1
			"show_dialogue":
				_action_show_dialogue()
			"await_dialogue":
				await DialogueManager.dialogue_finished
			"save":
				DataManager.save_game()
			"load":
				DataManager.create_or_load_file()
			_:
				_action_default()


func _action_default():
	var value = load(ca.value) if ca.value.contains("res://") else ca.value
	var node = get_node_or_null(ca.value)
	node_ref[ca.action] = node if node else value


func _action_set_swap_players():
	SwapPlayers.can_swap = ca.value


func _action_await_timer():
	var seconds = float(ca.value)
	await get_tree().create_timer(seconds).timeout


func _action_show_dialogue():
	assert(dialogue_resource != null, "\"dialogue_resource\" property needs to point to a DialogueResource.")
	dialogue_title = ca.value
	var balloon: Node = Balloon.instantiate()
	add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)


func _await_signal():
	await node_ref[ca.await_signal] if node_ref && ca.await_signal else null


func _on_dialogue_finished():
	print_debug("Dialogue ", dialogue_title, " finished")
