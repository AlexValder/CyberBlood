extends State
class_name EnemyState

@onready var _enemy := owner as BaseEnemy


func _add_gravity(delta: float) -> void:
    _enemy.velocity.y += delta * _enemy.GRAVITY
