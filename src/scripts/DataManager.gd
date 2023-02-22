# Takes care of loading or creating a new save game and provides appropriate
# resources to the user interface and the player.
extends Node

# We always keep a reference to the SaveGame resource here to prevent it from unloading.
var _save_data: SaveGame

@onready var players = get_tree().get_nodes_in_group("player")
@onready var states = get_tree().get_nodes_in_group("state")

#signal game_loaded


func _ready() -> void:
	# And the start of the game or when pressing the load button, we call this
	# function. It loads the save data if it exists, otherwise, it creates a 
	# new save file.
	_create_or_load_file()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		print_debug("saving...")
		_save_game()
	if event.is_action_pressed("load"):
		print_debug("loading...")
		_create_or_load_file()


func _create_or_load_file() -> void:
	if SaveGame.save_exists():
		_save_data = SaveGame.load_savegame()
	else:
		_save_data = SaveGame.new()
		_save_game()

	# After creating or loading a save resource, we need to dispatch its data
	# to the various nodes that need it.
	_load_game()


func _load_game() -> void:
	var location = _save_data.location
	_load_players_data()
	await get_tree().create_timer(0.1).timeout
	_load_states_data()
#	game_loaded.emit()


func _load_players_data():
	for i in players.size():
		players[i].player_data = _save_data.players[i]


func _load_states_data():
	for state in states:
		var path = String(state.get_path())
		var state_data = _save_data.states[path]
		state.state_data = state_data


func _save_game() -> void:
	_save_data.location = name
	_save_players_data()
	_save_states_data()
	_save_data.write_savegame()


func _save_players_data():
	for i in players.size():
		_save_data.players[i] = _get_player_data(players[i])


func _get_player_data(player) -> PlayerData:
	var player_data: = PlayerData.new()
	player_data.position = player.global_position
	player_data.active = player.active
	return player_data


func _save_states_data():
	for state in states:
		var path = String(state.get_path())
		_save_data.states[path] = _get_state_data(state)


func _get_state_data(state) -> StateData:
	var state_data: = StateData.new()
	state_data.state = state.state
	return state_data


