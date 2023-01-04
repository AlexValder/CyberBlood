extends PlayerState


func physics_process(_delta: float) -> void:
    if !player.is_on_floor():
        emit_signal("state_change", self.name, "fall")

    if Input.is_action_just_pressed("bat_form"):
        emit_signal("state_change", self.name, "bat_form")

    if Input.is_action_just_pressed("melee"):
        emit_signal("state_change", self.name, "attack1")

    if Input.is_action_just_pressed("jump"):
        emit_signal("state_change", self.name, "jump")

    if Input.is_action_pressed("left"):
        emit_signal("state_change", self.name, "run")

    if Input.is_action_pressed("right"):
        emit_signal("state_change", self.name, "run")
