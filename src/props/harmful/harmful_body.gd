extends Area2D

@export var damage: = 1


func _on_body_entered(body):
	if body:
		damage_entity(body)


func damage_entity(entity: CharacterEntity):
	entity.hp -= damage
