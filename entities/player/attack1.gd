extends PlayerState

var _next_attack := false


func on_entry() -> void:
    super.on_entry()
    player._sprite.animation_finished \
        .connect(_animation_done, CONNECT_ONE_SHOT)

    player.velocity = Vector2.ZERO


func _animation_done() -> void:
    if _next_attack:
        emit_signal("state_change", self.name, "attack2")
    elif !player.is_on_floor():
        emit_signal("state_change", self.name, "final_fall")
    else:
        emit_signal("state_change", self.name, "idle")


func physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("melee"):
        _next_attack = true


func on_exit() -> void:
    _next_attack = false
