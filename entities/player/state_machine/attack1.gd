extends PlayerState

var _next_attack := false


func on_entry() -> void:
    super.on_entry()
    if !player.player_anim.animation_finished.is_connected(_animation_done):
        player.player_anim.animation_finished \
            .connect(_animation_done, CONNECT_ONE_SHOT)

    player.velocity = Vector2.ZERO


func _animation_done(_anim: String) -> void:
    if _next_attack:
        state_change.emit(self.name, "attack2")
    elif !player.is_on_floor():
        state_change.emit(self.name, "final_fall")
    else:
        state_change.emit(self.name, "idle")


func physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("melee"):
        _next_attack = true


func on_exit() -> void:
    _next_attack = false
