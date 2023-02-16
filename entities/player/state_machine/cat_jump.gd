extends CatFormState


func on_entry() -> void:
    super.on_entry()
    player.velocity.y = -player.CAT_JUMP


func physics_process(delta: float) -> void:
    if !_process: return

    super.physics_process(delta)

    if is_zero_approx(player.velocity.y) and !player.is_on_ceiling():
        state_change.emit(self.name, "cat_idle")

    if Input.is_action_just_pressed("change_form"):
        state_change.emit(self.name, "idle")

    if player.velocity.y > 0:
        state_change.emit(self.name, "cat_fall")

    _check_horizontal_movement(player.CAT_SPEED)
    _add_gravity(delta)

    player.move_and_slide()
