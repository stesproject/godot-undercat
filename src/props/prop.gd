extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var area = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	animation_player.play("move")


func _on_body_exited(body):
	animation_player.play("move")
