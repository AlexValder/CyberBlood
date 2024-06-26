extends EnemyState


func on_entry() -> void:
    _enemy.play_anim("awoke", 1.75)


func physics_process(_delta: float) -> void:
    var distance := GameManager.player.global_position - _enemy.global_position
    var leng := distance.length()
    if leng >= _enemy.WATCH_DISTANCE:
        state_change.emit(self.name, "awoke")

    if distance.x > _enemy.THRESHOLD && _enemy.flip:
        _enemy.flip = false
    elif distance.x < -_enemy.THRESHOLD && !_enemy.flip:
        _enemy.flip = true

    if leng >= _enemy.ORBIT_DISTANCE && abs(distance.x) >= _enemy.THRESHOLD:
        _enemy.velocity.x = lerpf(
            _enemy.velocity.x,
            _enemy.FOLLOW_SPEED * (-1 if _enemy.flip else 1),
            _enemy.ACCEL
        )
    else:
        _enemy.velocity.x = lerpf(_enemy.velocity.x, 0.0, sin(_enemy.ACCEL * 2))

    if leng >= _enemy.ORBIT_DISTANCE && abs(distance.y) >= _enemy.THRESHOLD:
        _enemy.velocity.y = lerpf(
            _enemy.velocity.y,
            _enemy.FOLLOW_SPEED * .55 * \
                (-1 if distance.y < _enemy.THRESHOLD else 1),
            _enemy.ACCEL
        )
    else:
        _enemy.velocity.y = lerpf(_enemy.velocity.y, 0.0, _enemy.ACCEL)

    if leng <= _enemy.SEE_DISTANCE:
        state_change.emit(self.name, "ram_attack")

    if abs(distance.y) < 0.6:
        state_change.emit(self.name, "fire_attack")

    _enemy.move_and_slide()
