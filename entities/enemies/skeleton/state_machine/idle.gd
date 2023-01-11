extends EnemyState


func _process(_delta: float) -> void:
    _enemy.sprite.flip_h =\
         _enemy.global_position.x > GameManager.player.global_position.x


func physics_process(_delta) -> void:
    if !_enemy.is_on_floor():
        emit_signal("state_change", self.name, "fall")
