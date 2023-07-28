extends CharacterBody2D
class_name CharacterEntity

@export var hp: = 10: set = _set_hp
@export var max_hp: = 10
@export var health_bar_scn: PackedScene
@export var attack_power: = 2
@export var canvas_layer: Node
@export var anim_params: Array[String] = []

var health_bar: HealthBar
var animationTree: AnimationTree
var animationState: AnimationNodeStateMachinePlayback
var collision_shape: CollisionShape2D
var move_direction: = Vector2.DOWN: set = _set_move_direction
var is_moving: bool: get = _get_is_moving
var is_running: bool: get = _get_is_running
var on_grass = false

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var grass_shader = preload("res://src/shaders/trasparent.gdshader")
@onready var grass_shader_gradient = preload("res://src/shaders/transparent-gradient.tres")

signal hp_changed(value)


func _ready():
	_init_animation_tree()
	_init_health_bar()
	collision_shape = get_node("CollisionShape")


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
	if value < 0:
		value = 0
	elif value > max_hp:
		value = max_hp
	hp = value
	hp_changed.emit(hp)


func _set_move_direction(value):
	move_direction = value
	if animationTree && move_direction != Vector2.ZERO:
		for param in anim_params:
			animationTree.set("parameters/%s/blend_position" % param, move_direction)


func _get_is_moving():
	return velocity != Vector2.ZERO


func _get_is_running():
	return false


func toggle_grass_zone():
	var material = null
	if !on_grass:
		material = ShaderMaterial.new()
		material.shader = grass_shader
		material.set_shader_parameter("gradient_alpha", grass_shader_gradient)
		var texture_size = Vector2(sprite.texture.get_width(), sprite.texture.get_height())
		material.set_shader_parameter("sprite_sheet_size", texture_size)
		var frame_size = Vector2(texture_size.x / sprite.hframes, texture_size.y / sprite.vframes)
		material.set_shader_parameter("frame_size", frame_size)
	
	on_grass = !on_grass
	sprite.material = material
