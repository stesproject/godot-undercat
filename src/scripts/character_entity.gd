extends CharacterBody2D
class_name CharacterEntity

#@export var max_speed = 80.0
#@export var acceleration = 800.0
#@export var friction = 700.0
@export var animationTree: AnimationTree

var animationState: AnimationNodeStateMachinePlayback

var move_direction: = Vector2.DOWN:
	set(value):
		move_direction = value
		if animationTree && move_direction != Vector2.ZERO:
			animationTree.set("parameters/idle/blend_position", move_direction)
			animationTree.set("parameters/walk/blend_position", move_direction)


func _ready():
	if animationTree:
		animationTree.active = true
		animationState = animationTree.get("parameters/playback")


func _physics_process(delta):
	move_and_slide()

