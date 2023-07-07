extends CharacterEntity
class_name PlayerEntity

@export var player_id = 0
@export var max_speed = 200.0
@export var acceleration = 800.0
@export var friction = 800.0

@onready var active = player_id == 0

func _ready():
	super._ready()
	set_physics_process(active)
