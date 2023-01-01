extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity.y = -player.JUMP


func physics_process(delta: float) -> void:
    player.velocity.y += delta * player.GRAVITY

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

    if player.velocity.y > 0:
        emit_signal("state_change", self.name, "final_fall")

    player.move_and_slide()
