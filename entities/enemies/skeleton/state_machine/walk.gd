extends EnemyState

@export var _check_for_floor: RayCast2D


func _ready() -> void:
    assert(_check_for_floor != null)


func physics_process(_delta: float) -> void:
    if !_enemy.is_on_floor():
        state_change.emit(self.name, "fall")

    if GameManager.player != null:
        var eyes := _enemy.eyes.global_position
        var player := GameManager.player.global_position as Vector2
        if (eyes - player).length() < _enemy.SEES_PLAYER_AT:
            pass
            state_change.emit(self.name, "watch")

    if !_check_for_floor.is_colliding():
        _enemy.flip = !_enemy.flip

    _enemy.velocity.x = _enemy.WALK_SPEED * (-1 if _enemy.flip else 1)

    _enemy.move_and_slide()
