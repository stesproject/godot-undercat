extends CharacterBody2D
class_name CharacterEntity

@export var hp: = 10: set = _set_hp
@export var max_hp: = 10
@export var health_bar_scn: PackedScene
@export var canvas_layer: Node

var health_bar: HealthBar
var animationTree: AnimationTree
var animationState: AnimationNodeStateMachinePlayback
var move_direction: = Vector2.DOWN: set = _set_move_direction

signal hp_changed(value)


func _ready():
	_init_animation_tree()
	_init_health_bar()


func _physics_process(delta):
	move_and_slide()


func _init_animation_tree():
	animationTree = get_node("AnimationTree")
	if animationTree:
		animationTree.active = true
		animationState = animationTree.get("parameters/playback")


func _init_health_bar():
	if health_bar_scn && canvas_layer:
		health_bar = health_bar_scn.instantiate()
		health_bar.config_hud(self)
		canvas_layer.add_child(health_bar)


func _set_hp(value):
	hp = value
	hp_changed.emit(hp)


func _set_move_direction(value):
	move_direction = value
	if animationTree && move_direction != Vector2.ZERO:
		animationTree.set("parameters/idle/blend_position", move_direction)
		animationTree.set("parameters/walk/blend_position", move_direction)
