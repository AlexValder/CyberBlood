extends "res://entities/player/state_machine/dash.gd"


func on_entry() -> void:
    _start_dash = Time.get_ticks_msec()
    _can_dash = false
    _is_dashing = true
    _dash_left = player.flip
    player.velocity.y = 0
    player.velocity.x = DASH_SPEED/1.5 if !_dash_left else -DASH_SPEED/1.5

    player.play_anim("dash_attack")
    if !player.player_anim.animation_finished.is_connected(_on_anim_finished):
        player.player_anim.animation_finished.connect(
            _on_anim_finished.unbind(1), CONNECT_ONE_SHOT)
    _timer.start(DASH_TIME)


func physics_process(_delta: float) -> void:
    if !_is_dashing:
        return

    if Input.is_action_just_pressed("melee"):
        var diff := Time.get_ticks_msec() - _start_dash
        if diff <= TIME_TO_DASH_MS:
            state_change.emit(self.name, "dash_attack")

    if _dash_left && player.velocity.x < 0:
        player.velocity.x = min(player.velocity.x + DASH_DEACEL, 0)
    elif !_dash_left && player.velocity.x > 0:
        player.velocity.x = max(player.velocity.x - DASH_DEACEL, 0)

    if !_is_dashing:
        state_change.emit(self.name, "idle")

    player.move_and_slide()


func _on_anim_finished() -> void:
    _is_dashing = false
    state_change.emit(self.name, "idle")
