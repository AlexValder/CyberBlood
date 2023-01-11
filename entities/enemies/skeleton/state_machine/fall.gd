extends EnemyState


func physics_process(delta: float) -> void:
    if _enemy.is_on_floor():
        emit_signal("state_change", self.name, "idle")

    _enemy.velocity.y += delta * _enemy.GRAVITY
    _enemy.move_and_slide()
