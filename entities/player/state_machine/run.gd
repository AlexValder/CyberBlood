extends PlayerState


func physics_process(_delta: float) -> void:
    if !player.is_on_floor():
        emit_signal("state_change", self.name, "fall")

    if Input.is_action_just_pressed("bat_form"):
        emit_signal("state_change", self.name, "bat_form")

    if Input.is_action_just_pressed("cat_form"):
        emit_signal("state_change", self.name, "cat_idle")
        player.ensure_collision(player.PlayerForms.CAT)

    if Input.is_action_just_pressed("melee"):
        emit_signal("state_change", self.name, "attack1")

    _check_horizontal_movement(player.WALK_SPEED, "idle")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "jump")

    player.move_and_slide()
