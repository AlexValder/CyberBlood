extends EnemyState

const RAM_TIME := 0.3

@onready var _timer := $timer as Timer


func can_enter(_dir: Dictionary) -> bool:
    return (_timer.is_stopped() || is_zero_approx(_timer.time_left)) &&\
        _get_distance().length() <= _enemy.ORBIT_DISTANCE


func on_entry() -> void:
    _enemy.velocity = Vector2.ZERO
    _enemy.play_anim("ram_attack")

    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)


func physics_process(_delta: float) -> void:
    _enemy.move_and_slide()


func _animation_done(_anim: String) -> void:
    var origin := _enemy.global_position
    var end := origin + _get_distance().normalized() * \
        (3 * _enemy.ORBIT_DISTANCE as float)

    var tween := create_tween()
    tween.tween_property(_enemy, "global_position", end, RAM_TIME)
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
    _timer.start()
