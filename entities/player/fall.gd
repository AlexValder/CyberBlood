extends PlayerState


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        emit_signal("state_change", self.name, "idle")

    if Input.is_action_just_pressed("melee"):
        # TODO: air attack
        emit_signal("state_change", self.name, "attack1")

    if Input.is_action_just_pressed("bat_form"):
        emit_signal("state_change", self.name, "bat_form")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "double_jump")

    if Input.is_action_pressed("left"):
        player.velocity.x = lerp(player.velocity.x, \
            -player.WALK_SPEED, player.ACCEL)
        player._sprite.flip_h = true
    elif Input.is_action_pressed("right"):
        player.velocity.x =  lerp(player.velocity.x, \
            player.WALK_SPEED, player.ACCEL)
        player._sprite.flip_h = false
    else:
        player.velocity.x = lerp(player.velocity.x, 0.0, player.ACCEL)

    player.velocity.y += delta * player.GRAVITY
    player.move_and_slide()
