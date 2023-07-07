extends Node
class_name StateNode

@export var animation_state: String
@export var next_state: StateNode

@onready var state_machine: StateMachine = get_parent()

var entity: CharacterEntity

signal transitioned(params: Dictionary)


func _ready():
	entity = owner


func enter(params: Dictionary = {}):
	if animation_state && entity && entity.animationState:
		entity.animationState.travel(animation_state)


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func change_state(state: StateNode, params: Dictionary = {}):
	if !state: return
	transitioned.emit(self, state.name, params)
