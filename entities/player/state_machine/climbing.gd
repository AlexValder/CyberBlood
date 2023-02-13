extends PlayerState

var _ladder: Ladder


func on_entry() -> void:
    player.play_anim("idle")
    player.velocity = Vector2.ZERO
    player.set_collision_mask_value(9, false)
    _ladder.off_ladder.connect(get_off_ladder, CONNECT_ONE_SHOT)


func get_off_ladder() -> void:
    player.set_collision_mask_value(9, true)
    state_change.emit(self.name, "idle")


func can_enter(_dic: Dictionary) -> bool:
    var ladder := player.get_ladder()
    if ladder != null:
        _ladder = ladder
        return true
    return false


func physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("jump"):
        state_change.emit(self.name, "jump")
    elif Input.is_action_just_pressed("left"):
        state_change.emit(self.name, "idle")
    elif Input.is_action_just_pressed("right"):
        state_change.emit(self.name, "idle")

    _check_vertical_movement(player.WALK_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    _ladder = null
    player.set_collision_mask_value(9, true)
