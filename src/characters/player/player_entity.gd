extends CharacterEntity
class_name PlayerEntity

@export var player_id = 0
@export var max_speed = 200.0
@export var acceleration = 800.0
@export var friction = 800.0

@onready var active = player_id == 0
@onready var smoke_particles = $SmokeParticles

var player_data: PlayerData: set = _set_data


func _ready():
	super._ready()
	set_physics_process(active)


func _process(delta):
	smoke_particles.emitting = is_running && is_moving


func _set_data(value):
	player_data = value
	if player_data:
		global_position = player_data.position
		move_direction = player_data.direction
		active = player_data.active
#		collision_layer = player_layer if active else companion_layer


func _get_is_running():
	return Input.get_action_strength("run") > 0
