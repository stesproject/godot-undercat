class_name Entity
extends CharacterBody2D

@export var acceleration = 800.0
@export var friction = 700.0
@export var max_speed = 80
@export var target: Node2D = null:
	set(value):
		target = value
		_save_current_state()
		state = State.AUTO
		print(name, " set target: ", target.name)
@export var target_distance = 5.0

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

signal auto_move_finished

enum State {
	MOVE, AUTO, IDLE
}

var direction = Vector2.DOWN
var saved_state: State = State.IDLE
var state = State.MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true


func _physics_process(delta):
	_check_state(delta)


func _check_state(delta):
	match (state):
		State.MOVE:
			move_state(delta)
		State.AUTO:
			_auto_state(delta)
		State.IDLE:
			pass


func move_state(delta):
	pass
	
func _auto_state(delta):
	if target:
		var target_position = target.global_position
		if global_position.distance_to(target_position) > target_distance:
			_move_towards_point(target_position, delta)
		elif (velocity != Vector2.ZERO):
			animationTree.set("parameters/idle/blend_position", direction)
			velocity = Vector2.ZERO
			state = saved_state
			auto_move_finished.emit()
			update_animation()
		elif (velocity == Vector2.ZERO):
			pass


func _move_towards_point(target_position, delta):
	direction = global_position.direction_to(target_position)
	animationTree.set("parameters/walk/blend_position", direction)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	update_animation()
	move_and_slide()


func _save_current_state():
	saved_state = state
	
	
func update_animation():
	if velocity != Vector2.ZERO:
		animationState.travel("walk")
	else:
		animationState.travel("idle")


func set_direction(dir):
	direction = dir
	animationTree.set("parameters/idle/blend_position", direction)
	
