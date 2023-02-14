extends PlayerState

var _ladder: Ladder
var _getting_up := true


func on_entry() -> void:
    player.play_anim("idle")
    player.velocity = Vector2.ZERO
    player.set_collision_mask_value(9, false)
    if !_ladder.off_ladder.is_connected(get_off_ladder):
        _ladder.off_ladder.connect(get_off_ladder, CONNECT_ONE_SHOT)

    _getting_up = true
    player.flip = _ladder.facing_left
    var tween = get_tree().create_tween() as Tween
    tween\
        .tween_property(
            player, "global_position:x", _ladder.get_player_center(), 0.2)\
        .set_ease(Tween.EASE_OUT)\
        .set_trans(Tween.TRANS_QUAD)
    tween.tween_callback(func(): _getting_up = false)
    tween.play()


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

    var speed = player.velocity.length() * -signf(player.velocity.y)
    player.player_anim.speed_scale = speed / player.CLIMB_SPEED

    if !_getting_up:
        _check_vertical_movement(player.CLIMB_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    player.player_anim.speed_scale = 1.0
    _ladder = null
    player.set_collision_mask_value(9, true)
