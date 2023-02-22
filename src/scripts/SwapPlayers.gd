extends Node

@onready var players = get_tree().get_nodes_in_group("player")

var id = 0
var can_swap = false

signal player_swapped(id)

func _unhandled_input(event):
	if can_swap && event.is_action_pressed("swap_players"):
		swap_players()
			

func swap_players():
	if id < players.size() - 1:
		id += 1
	else:
		id = 0

	player_swapped.emit(id)
