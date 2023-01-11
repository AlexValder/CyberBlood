extends State
class_name PlayerState

@onready var player := self.owner as Player


# Some of reused logic
func _check_horizontal_movement(
    _delta: float, speed: float, idle_state: String = "") -> void:

    if Input.is_action_pressed("left"):
        player.velocity.x = lerp(player.velocity.x, -speed, player.ACCEL)
        player.flip = true
    elif Input.is_action_pressed("right"):
        player.velocity.x =  lerp(player.velocity.x, speed, player.ACCEL)
        player.flip = false
    else:
        player.velocity.x = lerp(player.velocity.x, 0.0, player.ACCEL)
        if idle_state.length() > 0:
            emit_signal("state_change", self.name, idle_state)


func _check_vertical_movement(
    _delta: float, speed: float, idle_state: String = "") -> void:

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
