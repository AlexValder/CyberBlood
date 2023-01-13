extends CatFormState


func can_enter(dir: Dictionary) -> bool:
    if dir.has("prev") && (dir.prev as String).begins_with("cat_"):
        return true

    if !player.has_mana(Constants.CAT_FORM_COST):
        return false

    player.use_mana(Constants.CAT_FORM_COST)
    player.ensure_collision(player.PlayerForms.CAT)

    return true


func physics_process(delta: float) -> void:
    super.physics_process(delta)

    if !player.is_on_floor():
        emit_signal("state_change", self.name, "cat_fall")

    if Input.is_action_just_pressed("change_form"):
        emit_signal("state_change", self.name, "idle")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "cat_jump")

    if Input.is_action_pressed("left"):
        emit_signal("state_change", self.name, "cat_walk")

    if Input.is_action_pressed("right"):
        emit_signal("state_change", self.name, "cat_walk")

