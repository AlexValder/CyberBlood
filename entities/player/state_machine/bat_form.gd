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


func physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("bat_form"):
        if player.can_transform(player.PlayerForms.HUMAN):
            emit_signal("state_change", self.name, "idle")

    _check_horizontal_movement(player.FLY_SPEED)
    _check_vertical_movement(player.FLY_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    super.on_exit()
    player.ensure_collision(player.PlayerForms.HUMAN)
