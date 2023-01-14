extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity.y = -player.JUMP


func physics_process(delta: float) -> void:
    if is_zero_approx(player.velocity.y) and !player.is_on_ceiling():
        state_change.emit(self.name, "idle")

    if Input.is_action_just_pressed("melee"):
        # TODO: air attack
        state_change.emit(self.name, "attack1")

    if Input.is_action_just_pressed("jump"):
        state_change.emit(self.name, "double_jump")

    if player.velocity.y > 0:
        state_change.emit(self.name, "fall")

    _check_horizontal_movement(player.WALK_SPEED)
    _add_gravity(delta)

    player.move_and_slide()

    super.physics_process(delta)
