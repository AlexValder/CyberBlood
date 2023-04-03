extends PlayerState


func physics_process(delta: float) -> void:
    if !_process: return

    if player.is_on_floor():
        state_change.emit(self.name, "idle")

    if Input.is_action_just_pressed("melee"):
        # TODO: air attack
        state_change.emit(self.name, "attack1")

    if Input.is_action_just_pressed("jump"):
        state_change.emit(self.name, "double_jump")

    if Input.is_action_just_pressed("up"):
        state_change.emit(self.name, "climbing")

    if Input.is_action_just_pressed("down"):
        state_change.emit(self.name, "climbing")

    _check_horizontal_movement(player.WALK_SPEED)

    player.velocity.y += delta * player.GRAVITY
    player.move_and_slide()

    super.physics_process(delta)
