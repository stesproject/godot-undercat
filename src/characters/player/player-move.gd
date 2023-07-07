extends StateNode


func physics_update(delta):
	move(delta)
	update_animation()


func move(delta):
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	if (input_vector != Vector2.ZERO):
		entity.move_direction = input_vector
		entity.velocity = entity.velocity.move_toward(input_vector * entity.max_speed, entity.acceleration * delta)
	else:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
	

func update_animation():
	if entity.velocity != Vector2.ZERO:
		entity.animationState.travel("walk")
	else:
		entity.animationState.travel("idle")
