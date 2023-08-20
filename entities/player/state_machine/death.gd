extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity = Vector2.ZERO


func physics_process(delta) -> void:
    _add_gravity(delta)
    player.move_and_slide()


func can_leave(_dir: Dictionary) -> bool:
    return false
