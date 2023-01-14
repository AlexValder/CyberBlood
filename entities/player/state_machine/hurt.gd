extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.player_anim.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)

    player.velocity = Vector2.ZERO


func _animation_done(_anim: String) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "final_fall")
    else:
        state_change.emit(self.name, "idle")
