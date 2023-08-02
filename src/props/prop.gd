extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable: Area2D = $Interactable

var tween: Tween


func _ready():
	interactable.connect("body_entered", _on_body_entered)
#	interactable.connect("body_exited", _on_body_exited)


func _on_body_entered(body):
	_play_tween(2)


func _on_body_exited(body):
	_play_tween(1)


func _play_tween(loops = 1):
	if tween:
		tween.kill()
	tween = create_tween().set_loops(loops)
	tween.tween_property(sprite, "rotation_degrees", 8, 0.05)
	tween.tween_property(sprite, "rotation_degrees", -8, 0.05)
	tween.tween_property(sprite, "rotation_degrees", 0, 0.07)
