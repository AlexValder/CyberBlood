extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity.y = -player.JUMP


func physics_process(delta: float) -> void:
    if is_zero_approx(player.velocity.y) and !player.is_on_ceiling():
        emit_signal("state_change", self.name, "idle")

    if Input.is_action_just_pressed("melee"):
        # TODO: air attack
        emit_signal("state_change", self.name, "attack1")

    if player.velocity.y > 0:
        emit_signal("state_change", self.name, "final_fall")

    _check_horizontal_movement(player.WALK_SPEED)
    _add_gravity(delta)

    player.move_and_slide()

    super.physics_process(delta)
