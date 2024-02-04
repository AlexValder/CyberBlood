extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity = Vector2.ZERO


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    if Input.is_action_just_pressed("melee"):
        state_change.emit(self.name, "attack1")

    if Input.is_action_just_pressed("jump"):
        if Input.is_action_pressed("down") && player.can_drop_down():
            player.start_drop_down()
            state_change.emit(self.name, "fall")
        else:
            state_change.emit(self.name, "jump")

    if Input.is_action_just_pressed("up"):
        state_change.emit(self.name, "climbing")

    if Input.is_action_just_pressed("down"):
        state_change.emit(self.name, "climbing")

    if Input.is_action_pressed("left") and player.is_on_floor():
        state_change.emit(self.name, "run")

    if Input.is_action_pressed("right") and player.is_on_floor():
        state_change.emit(self.name, "run")

    if Input.is_action_just_pressed("dash"):
        state_change.emit(self.name, "dash")

    player.move_and_slide()
    player.velocity.x = lerpf(player.velocity.x, 0.0, player.ACCEL)
    super.physics_process(delta)
