extends EnemyState

@onready var _timer := $timer as Timer


func can_enter(_dir: Dictionary) -> bool:
    return (_timer.is_stopped() || is_zero_approx(_timer.time_left)) &&\
        _get_distance().length() <= _enemy.ORBIT_DISTANCE


func on_entry() -> void:
    _enemy.velocity = Vector2.ZERO
    _enemy.play_anim("ram_attack")

    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done.bind(_get_distance()), CONNECT_ONE_SHOT)


func physics_process(_delta: float) -> void:
    if !_process: return

    _enemy.move_and_slide()


func _animation_done(_anim: String, dis: Vector2) -> void:
    var origin := _enemy.global_position
    var end := origin + 2 * dis

    var tween := create_tween()
    tween.tween_property(_enemy, "global_position", end, 0.3)
    tween.tween_callback(_tween_done)
    tween.play()


func _tween_done() -> void:
    state_change.emit(self.name, "track")


func _get_distance() -> Vector2:
    if GameManager.player == null:
        return Vector2.INF

    var enemy := _enemy.global_position
    var player := GameManager.player.global_position
    return player - enemy


func on_exit() -> void:
    super.on_exit()
    _timer.start()
