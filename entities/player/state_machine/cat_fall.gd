extends PlayerState


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        emit_signal("state_change", self.name, "cat_idle")

    if Input.is_action_just_pressed("cat_form"):
        if player.can_transform(player.PlayerForms.HUMAN):
            emit_signal("state_change", self.name, "idle")
            player.ensure_collision(player.PlayerForms.HUMAN)

    _check_horizontal_movement(player.WALK_SPEED)

    player.velocity.y += delta * player.GRAVITY
    player.move_and_slide()
