extends EnemyState


func on_entry() -> void:
    super.on_entry()
    _enemy.anim_player.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)

    _enemy.velocity = Vector2.ZERO


func _animation_done(_anim: String) -> void:
    if !_enemy.is_on_floor():
        state_change.emit(self.name, "fall")
    else:
        state_change.emit(self.name, "idle")
