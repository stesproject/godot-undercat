extends Resource
class_name Action

@export var enabled = true
## .. to access the State Manager
## ../.. to access the parent node
## ../../Node to access a child of the parent node
@export var node_ref = ""
@export var action = ""
@export var value = ""
@export var await_signal = "" 
