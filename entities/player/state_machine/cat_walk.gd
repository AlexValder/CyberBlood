extends CatFormState


func physics_process(delta: float) -> void:
    if !_process: return

    super.physics_process(delta)

    if !player.is_on_floor():
        state_change.emit(self.name, "cat_fall")

    if Input.is_action_just_pressed("change_form"):
        state_change.emit(self.name, "idle")

    _check_horizontal_movement(player.WALK_SPEED, "cat_idle")

    if Input.is_action_just_pressed("jump"):
        state_change.emit(self.name, "cat_jump")

    player.move_and_slide()
