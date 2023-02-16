extends PlayerState
class_name BatFormState


func can_enter(dir: Dictionary) -> bool:
    if dir.has("prev") && (dir.prev as String).begins_with("bat_"):
        return true

    if !player.has_mana(Constants.BAT_FORM_COST):
        return false

    player.use_mana(Constants.BAT_FORM_COST)
    player.ensure_collision(player.PlayerForms.BAT)

    return true


func can_leave(dir: Dictionary) -> bool:
    assert(dir.has("next"))
    assert((dir.next as String) != null)

    if dir.next.begins_with("bat_"):
        # no problem for transforming between states
        return true

    if player.can_transform(player.PlayerForms.HUMAN):
        player.ensure_collision(player.PlayerForms.HUMAN)
        return true
    else:
        return false


func physics_process(_delta: float) -> void:
    if !_process: return

    if Input.is_action_just_pressed("change_form"):
        state_change.emit(self.name, "idle")

    _check_horizontal_movement(player.FLY_SPEED)
    _check_vertical_movement(player.FLY_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    super.on_exit()
    player.ensure_collision(player.PlayerForms.HUMAN)
