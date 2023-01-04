extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player._sprite.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)


func _animation_done() -> void:
    emit_signal("state_change", self.name, "idle")


func physics_process(delta: float) -> void:
    pass
#    player.velocity.y += delta * player.GRAVITY
#    player.move_and_slide()
