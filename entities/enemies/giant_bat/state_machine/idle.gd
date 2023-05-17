extends EnemyState


func physics_process(_delta: float) -> void:
    if GameManager.player == null:
        return

    var distance := GameManager.player.global_position - _enemy.global_position
    if distance.length() <= _enemy.SEE_DISTANCE:
        state_change.emit(self.name, "awoke")
