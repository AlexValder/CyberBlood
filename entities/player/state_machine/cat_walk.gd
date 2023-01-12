extends CatFormState


func physics_process(_delta: float) -> void:
    if !player.is_on_floor():
        emit_signal("state_change", self.name, "cat_fall")

    if Input.is_action_just_pressed("cat_form"):
        if player.can_transform(player.PlayerForms.HUMAN):
            emit_signal("state_change", self.name, "idle")
            player.ensure_collision(player.PlayerForms.HUMAN)

    _check_horizontal_movement(player.WALK_SPEED, "cat_idle")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "cat_jump")

    player.move_and_slide()
