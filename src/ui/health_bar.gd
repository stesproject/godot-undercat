extends Control
class_name HealthBar

@export var value: = 0:
	set = _set_value
@export var max_value: = 0:
	set = _set_max_value

@onready var hud_full: TextureRect = $HudFull
@onready var hud_empty: TextureRect = $HudEmpty
@onready var gap = hud_full.size.x

var entity: CharacterEntity = null


func config_hud(entity_ref: CharacterEntity):
	await self.ready
	entity = entity_ref
	max_value = entity.max_hp
	value = entity.hp
	entity.connect("hp_changed", _on_hp_changed)


func _set_value(new_value):
	value = new_value
	hud_full.size.x = gap * new_value


func _set_max_value(new_value):
	max_value = new_value
	hud_empty.size.x = gap * new_value


func _on_hp_changed(hp):
	value = hp
