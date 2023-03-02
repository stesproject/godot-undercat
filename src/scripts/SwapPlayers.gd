extends Node

@onready var players = get_tree().get_nodes_in_group("player")

var active_player_id = -1
var can_swap := false

signal player_swapped(player_id)

func _unhandled_input(event):
	if can_swap && event.is_action_pressed("swap_players"):
		swap_players()
			

func swap_players():
	if active_player_id == -1:
		set_active_player_id()
	if active_player_id < players.size() - 1:
		active_player_id += 1
	else:
		active_player_id = 0

	player_swapped.emit(active_player_id)


func set_active_player_id():
	for player in players:
		if player.active:
			active_player_id = player.player_id
			break
