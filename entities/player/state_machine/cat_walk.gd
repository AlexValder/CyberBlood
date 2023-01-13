extends CatFormState


func physics_process(delta: float) -> void:
    super.physics_process(delta)

    if !player.is_on_floor():
        emit_signal("state_change", self.name, "cat_fall")

    if Input.is_action_just_pressed("change_form"):
        emit_signal("state_change", self.name, "idle")

    _check_horizontal_movement(player.WALK_SPEED, "cat_idle")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "cat_jump")

    player.move_and_slide()
