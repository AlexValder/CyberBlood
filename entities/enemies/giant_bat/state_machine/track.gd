extends EnemyState


func on_entry() -> void:
    _enemy.play_anim("idle", 1.75)
    _process = true


func physics_process(delta: float) -> void:
    if !_process: return

    var distance := GameManager.player.global_position - _enemy.global_position
    var len := distance.length()
    if len > _enemy.WATCH_DISTANCE:
        state_change.emit(self.name, "idle")

    _enemy.flip =\
        GameManager.player.global_position.x < _enemy.global_position.x

    _check_horizontal_movement(
        _enemy.FOLLOW_SPEED,
        distance.x if abs(distance.x) > _enemy.FOLLOW_DISTANCE else 0)

    _enemy.move_and_slide()
