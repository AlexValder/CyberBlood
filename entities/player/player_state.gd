extends Node
class_name PlayerState

signal state_change(old_state, new_state)

var player: Player = null


func on_entry() -> void:
    player.play_anim(self.name)


func on_exit() -> void:
    pass


func process(_delta: float) -> void:
    pass


func physics_process(_delta: float) -> void:
    pass


# Some of reused logic
func _check_horizontal_movement(
    delta: float, speed: float, idle_state: String = "") -> void:

    if Input.is_action_pressed("left"):
        player.velocity.x = lerp(player.velocity.x, -speed, player.ACCEL)
        player._sprite.flip_h = true
    elif Input.is_action_pressed("right"):
        player.velocity.x =  lerp(player.velocity.x, speed, player.ACCEL)
        player._sprite.flip_h = false
    else:
        player.velocity.x = lerp(player.velocity.x, 0.0, player.ACCEL)
        if idle_state.length() > 0:
            emit_signal("state_change", self.name, idle_state)


func _check_vertical_movement(
    delta: float, speed: float, idle_state: String = "") -> void:

    if Input.is_action_pressed("up"):
        player.velocity.y = lerp(player.velocity.y, -speed, player.ACCEL)
    elif Input.is_action_pressed("down"):
        player.velocity.y = lerp(player.velocity.y, speed, player.ACCEL)
    else:
        player.velocity.y = lerp(player.velocity.y, 0.0, player.ACCEL)
        if idle_state.length() > 0:
            emit_signal("state_change", self.name, idle_state)


func _add_gravity(delta: float) -> void:
    player.velocity.y += delta * player.GRAVITY
