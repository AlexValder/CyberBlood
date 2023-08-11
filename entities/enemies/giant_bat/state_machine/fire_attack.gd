extends EnemyState

@onready var _timer := $timer as Timer


func can_enter(_dir: Dictionary) -> bool:
    return _timer.is_stopped() || is_zero_approx(_timer.time_left)


func on_entry() -> void:
    _enemy.velocity = Vector2.ZERO
    _enemy.play_anim("fire_attack")

    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)


func physics_process(_delta: float) -> void:
    _enemy.move_and_slide()


func _animation_done(_anim: String) -> void:
    state_change.emit(self.name, "track")


func on_exit() -> void:
    _timer.start()
