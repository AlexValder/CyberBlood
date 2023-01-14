extends PlayerState


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        state_change.emit(self.name, "idle")

    if Input.is_action_just_pressed("melee"):
        # TODO: air attack
        state_change.emit(self.name, "attack1")

    _check_horizontal_movement(player.WALK_SPEED)
    _add_gravity(delta)

    player.move_and_slide()

    super.physics_process(delta)
