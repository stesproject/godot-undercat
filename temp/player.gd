extends Entity

@export var player_id = 0

@onready var active = player_id == 0
@onready var remoteTransform = $RemoteTransform2D
@onready var mainCamera: Camera2D = get_tree().current_scene.find_child("Camera2D")

const player_layer = 1
const companion_layer = 8

var player_data: PlayerData:
	set(value):
		player_data = value
		if player_data:
			global_position = player_data.position
			set_direction(player_data.direction)
			active = player_data.active
			collision_layer = player_layer if active else companion_layer


func _ready():
	super._ready()
	SwapPlayers.player_swapped.connect(on_player_swapped)
	auto_move_finished.connect(on_auto_move_finished)
	check_enable_player(0)


func move_state(delta):
	if !active: return

	var input_vector = Input.get_vector("left", "right", "up", "down")
#	velocity = input_vector * acceleration  if friction == 0 else velocity
	if (input_vector != Vector2.ZERO):
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/walk/blend_position", input_vector)
		direction = input_vector
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	update_animation()
	move_and_slide()


func check_enable_player(id):
	active = player_id == id
#	remoteTransform.remote_path = mainCamera.get_path() if mainCamera else ""
	collision_layer = player_layer if active else companion_layer

func on_player_swapped(id):
	check_enable_player(id)

func on_auto_move_finished():
	check_enable_player(SwapPlayers.active_player_id)
