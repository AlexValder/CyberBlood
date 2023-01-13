extends CatFormState


func on_entry() -> void:
    super.on_entry()
    player.velocity.y = -player.JUMP


func physics_process(delta: float) -> void:
    super.physics_process(delta)

    if is_zero_approx(player.velocity.y) and !player.is_on_ceiling():
        emit_signal("state_change", self.name, "cat_idle")

    if Input.is_action_just_pressed("change_form"):
        emit_signal("state_change", self.name, "idle")

    if player.velocity.y > 0:
        emit_signal("state_change", self.name, "cat_fall")

    _check_horizontal_movement(player.WALK_SPEED)
    _add_gravity(delta)

    player.move_and_slide()
