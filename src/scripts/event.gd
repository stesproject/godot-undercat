extends Node2D
class_name Event

@export var dialogue_resource: DialogueResource
@export var actions: Array[Action] = []

@onready var _state_manager: StateManager = get_parent()
@onready var _index = get_index()

const Balloon = preload("res://src/dialogues/portraits_balloon/balloon.tscn")

var ca = null # current action
var action_value
var node_ref = null
var dialogue_title = ""
var tween: Tween = null

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
		action_value = ca.value.value if ca.value else null
		await _await_signal()
		if ca.action != "tween" && tween != null && tween.is_running():
			await tween.finished
			
		match ca.action:
			"set-swap-players":
				_action_set_swap_players()
			"await-timer":
				await _action_await_timer()
			"next":
				_state_manager.state += int(action_value) if action_value else 1
			"show-dialogue":
				_action_show_dialogue()
			"await-dialogue":
				await DialogueManager.dialogue_finished
			"tween":
				_action_tween()
			"screenshot":
				_action_screenshot()
			"play-anim":
				_action_play_animation()
			"save":
				DataManager.save_game()
			"load":
				DataManager.create_or_load_file()
			_:
				_action_default()


func _action_default():
	if ca.action == "": return
	var should_load = typeof(action_value) == TYPE_OBJECT
	var is_node = typeof(action_value) == TYPE_NODE_PATH
	var value = action_value
	if should_load:
		value = load(value.load_path)
	elif is_node:
		value = get_node_or_null(value)
	node_ref[ca.action] = value
	print("Action -> node: ", node_ref.name, " | param: ", ca.action, " | value: ", value)


func _action_set_swap_players():
	SwapPlayers.can_swap = action_value.to_lower() == "true"


func _action_await_timer():
	var seconds = float(action_value)
	await get_tree().create_timer(seconds).timeout


func _action_show_dialogue():
	assert(dialogue_resource != null, "\"dialogue_resource\" property needs to point to a DialogueResource.")
	dialogue_title = action_value
	var balloon: Node = Balloon.instantiate()
	add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)


func _action_screenshot():
	var image = get_viewport().get_texture().get_image()
#	image.save_png("screenshot.png")
	var img_texture = ImageTexture.new()
	var texture = img_texture.create_from_image(image)
	node_ref.texture = texture


func _action_play_animation():
	var anim_player: AnimationPlayer = node_ref
	anim_player.play(action_value)


func _action_tween():
	tween = create_tween() if tween == null else tween
	tween.set_parallel(true)
	var tp: TweenValue = ca.value
	var tween_obj = get_node_or_null(ca.node_ref)
	if tp && tween_obj:
		var start_value = tween_obj[tp.property]
		var end_value = tp.value.value
		tween.tween_method(
#			func(v): tween_obj[tp.property] = start_value.lerp(end_value, tp.curve.sample_baked(v)),
			func(v): tween_obj[tp.property] = lerp(start_value, end_value, tp.curve.sample_baked(v)),
			0.0, 1.0, tp.duration)


func _await_signal():
	if node_ref && ca.await_signal:
		print(node_ref.name, " is awaiting for signal: ", ca.await_signal)
		await node_ref[ca.await_signal]


func _on_dialogue_finished():
	print("Dialogue ", dialogue_title, " finished")
