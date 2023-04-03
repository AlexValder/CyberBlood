extends EnemyState


func on_entry() -> void:
    super.on_entry()
    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)

    _enemy.velocity = Vector2.ZERO


func physics_process(delta: float) -> void:
    if !_process: return

    _add_gravity(delta)
    _enemy.move_and_slide()


func _animation_done(_anim: String) -> void:
    state_change.emit(self.name, "watch")
