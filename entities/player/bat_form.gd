extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.ensure_collision("bat")


func physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("bat_form"):
        emit_signal("state_change", self.name, "idle")

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

    if Input.is_action_pressed("up"):
        player.velocity.y = lerp(player.velocity.y, \
            -player.WALK_SPEED, player.ACCEL)
    elif Input.is_action_pressed("down"):
        player.velocity.y = lerp(player.velocity.y, \
            player.WALK_SPEED, player.ACCEL)
    else:
        player.velocity.y = lerp(player.velocity.y, 0.0, player.ACCEL)

    player.move_and_slide()


func on_exit() -> void:
    super.on_exit()
    player.ensure_collision("human")
