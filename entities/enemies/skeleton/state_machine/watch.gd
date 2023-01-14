extends EnemyState

@onready var _timer := $forget_timer as Timer
@onready var _attack_pause := $attack_pause as Timer

var _sees := true
var _attacking := false


func on_entry() -> void:
    _enemy.play_anim("idle")
    _enemy.velocity.x = 0
    _sees = true


func can_enter(dir: Dictionary) -> bool:
    if (dir.prev as String).begins_with("attack"):
        _attacking = true
        _attack_pause.start()

    return true


func process(_delta: float) -> void:
    if _sees:
        owner.flip = \
            owner.global_position.x > GameManager.player.global_position.x


func physics_process(delta: float) -> void:
    _add_gravity(delta)

    var distance: float = 10000.0
    if GameManager.player != null:
        var eyes := _enemy.eyes.global_position
        var player := GameManager.player.global_position
        distance = (eyes - player).length()

    if distance <= _enemy.ATTACK_DISTANCE && !_attacking:
        _attacking = true
        state_change.emit(self.name, "attack1")
    elif distance >= _enemy.KEEPS_SEEING:
        _sees = false
        if _timer.is_stopped():
            _timer.start()
    else:
        _sees = true
        _timer.stop()


func _on_timer_timeout() -> void:
    state_change.emit(self.name, "idle")


func _on_attack_pause_timeout() -> void:
    _attacking = false
