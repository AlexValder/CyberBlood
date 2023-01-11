extends EnemyState


func on_entry() -> void:
    super.on_entry()
    _enemy.sprite.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)

    _enemy.velocity = Vector2.ZERO


func _animation_done() -> void:
    if !_enemy.is_on_floor():
        emit_signal("state_change", self.name, "fall")
    else:
        emit_signal("state_change", self.name, "idle")
