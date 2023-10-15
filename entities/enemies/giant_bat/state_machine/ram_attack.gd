extends EnemyState

const RAM_TIME := 0.3

@onready var _timer := $timer as Timer

var _tween: Tween


func can_enter(_dir: Dictionary) -> bool:
    return (_timer.is_stopped() || is_zero_approx(_timer.time_left)) &&\
        _get_distance().length() <= _enemy.ORBIT_DISTANCE


func on_entry() -> void:
    _enemy.velocity = Vector2.ZERO
    _enemy.play_anim(self.name)

    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)


func physics_process(_delta: float) -> void:
    _enemy.move_and_slide()


func _animation_done(anim: String) -> void:
    if anim != self.name:
        return

    var origin := _enemy.global_position
    var end := origin + _get_distance().normalized() * \
        (3 * _enemy.ORBIT_DISTANCE as float)

    if _tween != null:
        _tween.kill()
        _tween = null
    var _tween := create_tween()
    _tween.tween_property(_enemy, "global_position", end, RAM_TIME)
    _tween.tween_callback(_tween_done)
    _tween.play()


func _tween_done() -> void:
    state_change.emit(self.name, "track")
    _tween = null


func _get_distance() -> Vector2:
    if GameManager.player == null:
        return Vector2.INF

    var enemy := _enemy.global_position
    var player := GameManager.player.global_position
    return player - enemy


func on_exit() -> void:
    _timer.start()
    if _tween != null:
        _tween.kill()
        _tween = null
