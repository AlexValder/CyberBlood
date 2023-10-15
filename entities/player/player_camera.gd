extends Camera2D
class_name PlayerCamera

var player: Player
var _target: Node2D
var _ignore_y := false


func set_limits(vec: Vector4i) -> void:
    limit_left = vec[0]
    limit_top = vec[1]
    limit_right = vec[2]
    limit_bottom = vec[3]


func setup_player() -> void:
    player.state_machine.state_transition.connect(_on_state_change)
    _target = player.get_node("areas/camera_target") as Node2D
    assert(_target != null)
    global_position = _target.global_position


func _ready() -> void:
    enabled = false
    set_process(false)


func _process(_delta: float) -> void:
    global_position.x = _target.global_position.x
    if !_ignore_y:
        global_position.y = _target.global_position.y


func _on_state_change(old: String, new: String) -> void:
    Logger.debug("CAMERA: %s -> %s" % [old, new])
