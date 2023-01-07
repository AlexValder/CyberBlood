extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player._sprite.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)

    player.velocity = Vector2.ZERO


func _animation_done() -> void:
    if player.is_on_floor():
        emit_signal("state_change", self.name, "idle")
    else:
        emit_signal("state_change", self.name, "final_fall")
