extends PlayerState


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    if Input.is_action_just_pressed("melee"):
        state_change.emit(self.name, "attack1")

    _check_horizontal_movement(player.WALK_SPEED, "idle")

    if Input.is_action_just_pressed("jump"):
        state_change.emit(self.name, "jump")

    if Input.is_action_pressed("dash"):
        state_change.emit(self.name, "dash")

    player.move_and_slide()

    super.physics_process(delta)
