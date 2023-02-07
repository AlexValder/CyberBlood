extends EnemyState

signal start_patrolling


func on_entry() -> void:
    super.on_entry()
    start_patrolling.emit()


func physics_process(_delta) -> void:
    if !_enemy.is_on_floor():
        state_change.emit(self.name, "fall")

    if GameManager.player != null:
        var eyes := _enemy.eyes.global_position
        var player := GameManager.player.global_position as Vector2
        if (eyes - player).length() < _enemy.SEES_PLAYER_AT:
            state_change.emit(self.name, "watch")
