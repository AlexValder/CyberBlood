extends State
class_name EnemyState

@onready var _enemy := owner as BaseEnemy


func _add_gravity(delta: float) -> void:
    _enemy.velocity.y += delta * _enemy.GRAVITY


func _check_horizontal_movement(
    speed: float, param: float, idle_state: String = "") -> void:

    if param < 0:
        _enemy.velocity.x = lerp(_enemy.velocity.x, -speed, _enemy.ACCEL)
        _enemy.flip = true
    elif param > 0:
        _enemy.velocity.x = lerp(_enemy.velocity.x, speed, _enemy.ACCEL)
        _enemy.flip = false
    else:
        _enemy.velocity.x = lerp(_enemy.velocity.x, 0.0, _enemy.ACCEL)
        if idle_state.length() > 0:
            state_change.emit(self.name, idle_state)


func _check_vertical_movement(
    speed: float, param: float,idle_state: String = "") -> void:

    if param < 0:
        _enemy.velocity.y = lerp(_enemy.velocity.y, -speed, 1)
    elif param > 0:
        _enemy.velocity.y = lerp(_enemy.velocity.y, speed, 1)
    else:
        _enemy.velocity.y = lerp(_enemy.velocity.y, 0.0, 1)
        if idle_state.length() > 0:
            state_change.emit(self.name, idle_state)
