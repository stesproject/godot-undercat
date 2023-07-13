extends StateNode

@export var run_speed_increment: = 2.0


func physics_update(delta):
	move(delta)
	update_animation()


func move(delta):
	var input_vector = Input.get_vector("left", "right", "up", "down")
	var max_speed = entity.max_speed if !entity.is_running else entity.max_speed * run_speed_increment
	
	if (input_vector != Vector2.ZERO):
		entity.move_direction = input_vector
		entity.velocity = entity.velocity.move_toward(input_vector * max_speed, entity.acceleration * delta)
	else:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
	

func update_animation():
	if entity.is_running:
		entity.animationState.travel("run")
	elif entity.is_moving:
		entity.animationState.travel("walk")
	else:
		entity.animationState.travel("idle")
