extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity.x = 0
    if !player.player_anim.animation_finished.is_connected(_animation_done):
        player.player_anim.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        player.velocity.x = lerpf(player.velocity.x, 0.0, player.ACCEL)

    _add_gravity(delta)
    player.move_and_slide()


func _animation_done(_anim: String) -> void:
    if player.is_on_floor():
        state_change.emit(self.name, "idle")
    else:
        state_change.emit(self.name, "final_fall")
