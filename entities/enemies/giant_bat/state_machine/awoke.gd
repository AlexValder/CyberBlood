extends EnemyState

@onready var _timer := $timer as Timer


func on_entry() -> void:
    super.on_entry()
    _enemy.velocity = Vector2.ZERO
    _timer.start(randf_range(0.1, 2.5))


func physics_process(_delta: float) -> void:
    if GameManager.player == null:
        return

    var distance := GameManager.player.global_position - _enemy.global_position
    if distance.length() <= _enemy.SEE_DISTANCE:
        state_change.emit(self.name, "track")

    _enemy.velocity = Vector2.ZERO
    _enemy.move_and_slide()


func on_exit() -> void:
    _timer.stop()


func _on_flip_timer_timeout() -> void:
    _enemy.flip = !_enemy.flip
    _timer.start(randf_range(0.1, 2.5))
