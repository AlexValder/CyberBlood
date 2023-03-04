extends EnemyState


func on_entry() -> void:
    super.on_entry()
    if !_enemy.anim_player.animation_finished.is_connected(_animation_done):
        _enemy.anim_player.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)

    _enemy.velocity.x = 0


func physics_process(delta: float) -> void:
    if !_process: return

    _add_gravity(delta)
    _enemy.move_and_slide()


func _animation_done(_anim: String) -> void:
    var eyes := _enemy.global_position
    var player := GameManager.player.global_position as Vector2
    var distance := (eyes - player).length()

    if distance <= _enemy.ATTACK_DISTANCE:
        state_change.emit(self.name, "attack2")
    else:
        state_change.emit(self.name, "watch")
