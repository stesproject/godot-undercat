# Save and load the game using the text or binary resource format.
class_name SaveGame
extends Resource

# You must use the user:// path prefix when saving the player's data.
#
# We removed the extension in this demo to show how to save as text during
# development or in debug builds and binary in the released game.
#
# See the get_save_path() function below.
const SAVE_GAME_BASE_PATH := "user://save"

# Use this to detect old player saves and update their data.
@export var version := 1

@export var players: Dictionary = {}
@export var states: Dictionary = {}
@export var location := ""


func write_savegame() -> void:
	ResourceSaver.save(self, get_save_path())


static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())


static func load_savegame() -> Resource:
	var save_path := get_save_path()
	if ResourceLoader.exists(save_path):
		return ResourceLoader.load(save_path, "", 0)
	return null


static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"


# This function allows us to save and load a text resource in debug builds and a
# binary resource in the released product.
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension
