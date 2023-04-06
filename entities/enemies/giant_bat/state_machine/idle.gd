extends EnemyState


func physics_process(_delta: float) -> void:
    _enemy.move_and_slide()
