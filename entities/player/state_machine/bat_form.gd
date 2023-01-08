extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.ensure_collision(player.PlayerForms.BAT)


func can_enter(dir: Dictionary) -> bool:
    if !dir.has("prev"):
        return false

    if !player.has_mana(Constants.BAT_FORM_COST):
        return false

    return true


func can_leave() -> bool:
    return player.can_transform(player.PlayerForms.HUMAN)


func physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("bat_form"):
        emit_signal("state_change", self.name, "idle")

    _check_horizontal_movement(delta, player.FLY_SPEED)
    _check_vertical_movement(delta, player.FLY_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    super.on_exit()
    player.ensure_collision(player.PlayerForms.HUMAN)
