extends PlayerState

const DASH_SPEED := 400.0*2
const DASH_DEACEL := 10.0*2
const DASH_TIME := 1.0
const DASH_COOLDOWN := 0.5

@export var TIME_TO_DASH_MS := 300
@onready var _timer := $timer as Timer
@onready var _cooldown := $cooldown as Timer
var _can_dash := true
var _dash_left := true
var _is_dashing := false
var _start_dash: int


func on_entry() -> void:
    # TODO: animation
    _start_dash = Time.get_ticks_msec()
    _can_dash = false
    _is_dashing = true
    _dash_left = player.flip
    player.velocity.y = 0
    player.velocity.x = DASH_SPEED if !_dash_left else -DASH_SPEED

    _timer.start(DASH_TIME)


func can_enter(_dir: Dictionary) -> bool:
    return _can_dash


func physics_process(_delta: float) -> void:
    if !_is_dashing:
        return

    # dash cancel
    if Input.is_action_just_pressed("jump"):
        _timer.stop()
        if player.velocity.y <= 0:
            state_change.emit(self.name, "double_jump")
        else:
            state_change.emit(self.name, "final_fall")
        return

    if Input.is_action_just_pressed("melee"):
        var diff := Time.get_ticks_msec() - _start_dash
        print(diff)
        if diff <= TIME_TO_DASH_MS:
            state_change.emit(self.name, "dash_attack")

    if _dash_left && player.velocity.x < 0:
        player.velocity.x = min(player.velocity.x + DASH_DEACEL, 0)
    elif !_dash_left && player.velocity.x > 0:
        player.velocity.x = max(player.velocity.x - DASH_DEACEL, 0)

    if is_zero_approx(player.velocity.x):
        state_change.emit(self.name, "idle")

    player.move_and_slide()


func on_exit() -> void:
    _timer.stop()
    _cooldown.start(DASH_COOLDOWN)


func _on_cooldown_timeout() -> void:
    _can_dash = true


func _on_dash_end() -> void:
    _is_dashing = false
    state_change.emit(self.name, "idle")
