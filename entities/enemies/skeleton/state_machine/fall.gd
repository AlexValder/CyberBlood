extends EnemyState


func on_entry() -> void:
    _enemy.play_anim("idle")


func physics_process(delta: float) -> void:
    if _enemy.is_on_floor():
        state_change.emit(self.name, "idle")

    _enemy.velocity.y += delta * _enemy.GRAVITY
    _enemy.move_and_slide()
