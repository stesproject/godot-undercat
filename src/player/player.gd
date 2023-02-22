extends Entity

@export var PLAYER_ID = 0

@onready var active = PLAYER_ID == 0
@onready var remoteTransform = $RemoteTransform2D
@onready var mainCamera: Camera2D = get_tree().current_scene.find_child("Camera2D")

const player_layer = 1
const companion_layer = 4

func _ready():
	super._ready()
	SwapPlayers.player_swapped.connect(on_player_swapped)
	auto_move_finished.connect(on_auto_move_finished)
	collision_layer = player_layer if active else companion_layer
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
	active = PLAYER_ID == id
	remoteTransform.remote_path = mainCamera.get_path() if mainCamera else ""
	collision_layer = player_layer if active else companion_layer

func on_player_swapped(id):
	check_enable_player(id)

func on_auto_move_finished():
	check_enable_player(SwapPlayers.id)
