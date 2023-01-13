extends State
class_name PlayerState

@onready var player := self.owner as Player

# common logic
func physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("change_form"):
        emit_signal("state_change", self.name, player.tranform_name())

    if Input.is_action_just_pressed("next_form"):
        player.next_form()

# Some of reused logic
func _check_horizontal_movement(
    speed: float, idle_state: String = "") -> void:

    if Input.is_action_pressed("left"):
        player.velocity.x = lerp(player.velocity.x,
            -speed * Input.get_action_strength("left"), player.ACCEL)
        player.flip = true
    elif Input.is_action_pressed("right"):
        player.velocity.x =  lerp(player.velocity.x,
            speed * Input.get_action_strength("right"), player.ACCEL)
        player.flip = false
    else:
        player.velocity.x = lerp(player.velocity.x, 0.0, player.ACCEL)
        if idle_state.length() > 0:
            emit_signal("state_change", self.name, idle_state)


func _check_vertical_movement(
    speed: float, idle_state: String = "") -> void:

    if Input.is_action_pressed("up"):
        player.velocity.y = lerp(player.velocity.y,
            -speed * Input.get_action_strength("up"), player.ACCEL)
    elif Input.is_action_pressed("down"):
        player.velocity.y = lerp(player.velocity.y,
            speed * Input.get_action_strength("down"), player.ACCEL)
    else:
        player.velocity.y = lerp(player.velocity.y, 0.0, player.ACCEL)
        if idle_state.length() > 0:
            emit_signal("state_change", self.name, idle_state)


func _add_gravity(delta: float) -> void:
    player.velocity.y += delta * player.GRAVITY
