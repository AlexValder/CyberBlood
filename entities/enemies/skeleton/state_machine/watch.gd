extends EnemyState

@export var _obstacle_area: Area2D
@export var _check_for_floor: RayCast2D

@onready var _timer := $forget_timer as Timer
@onready var _attack_pause := $attack_pause as Timer

var _sees := true
var _attacking := false


func _ready() -> void:
    assert(_obstacle_area != null)
    assert(_check_for_floor != null)


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
        var enemy := owner.global_position.x as float
        var player := GameManager.player.global_position.x as float
        if (abs(enemy - player) >= 0.01):
            owner.flip = enemy > player


func physics_process(delta: float) -> void:
    _add_gravity(delta)
    _enemy.move_and_slide()

    if GameManager.player == null:
        return

    var eyes := _enemy.eyes.global_position
    var player := GameManager.player.global_position as Vector2
    var distance := (eyes - player).length()

    if distance <= _enemy.ATTACK_DISTANCE && !_attacking:
        _attacking = true
        state_change.emit(self.name, "attack1")
    elif distance <= _enemy.KEEPS_SEEING && _can_chase(abs(eyes.x - player.x)):
        state_change.emit(self.name, "chase")
    elif distance > _enemy.KEEPS_SEEING:
        _sees = false
        if _timer.is_stopped():
            _timer.start()
    else:
        _sees = true
        _timer.stop()


func _can_chase(distance_x: float) -> bool:
    return distance_x >= 2.0 && \
        _check_for_floor.is_colliding() && \
        !_obstacle_area.has_overlapping_bodies()


func _on_timer_timeout() -> void:
    state_change.emit(self.name, "idle")


func _on_attack_pause_timeout() -> void:
    _attacking = false
