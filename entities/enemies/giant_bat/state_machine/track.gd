extends EnemyState


func on_entry() -> void:
    _enemy.play_anim("idle", 1.75)
    _process = true


func physics_process(delta: float) -> void:
    if !_process: return

    var distance := GameManager.player.global_position - _enemy.global_position
    var len := distance.length()
    if len >= _enemy.WATCH_DISTANCE:
        state_change.emit(self.name, "idle")

    _enemy.flip = distance.x < 0

    if abs(distance.x) >= _enemy.THRESHOLD:
        _enemy.velocity.x = lerp(
            _enemy.velocity.x,
            _enemy.FOLLOW_SPEED * (-1 if _enemy.flip else 1),
            _enemy.ACCEL
        )
    else:
        _enemy.velocity.x = lerp(_enemy.velocity.x, 0.0, sin(_enemy.ACCEL * 2))

    if abs(distance.y) >= _enemy.THRESHOLD:
        _enemy.velocity.y = lerp(
            _enemy.velocity.y,
            _enemy.FOLLOW_SPEED * .55 * \
                (-1 if distance.y < _enemy.THRESHOLD else 1),
            _enemy.ACCEL
        )
    else:
        _enemy.velocity.y = lerp(_enemy.velocity.y, 0.0, _enemy.ACCEL)

    _enemy.move_and_slide()
