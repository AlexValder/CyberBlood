extends EnemyState


func on_entry() -> void:
    super.on_entry()
    _enemy.velocity = Vector2.ZERO


func can_leave(_dir: Dictionary) -> bool:
    return false
