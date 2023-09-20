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
#    position_smoothing_enabled = false
    player.state_machine.state_transition.connect(_on_state_change)
    _target = player.get_node("areas/camera_target") as Node2D
    assert(_target != null)
    global_position = _target.global_position
    # HACK: timer T_T
#    get_tree().create_timer(0.1).timeout.connect(
#        func(): position_smoothing_enabled = true)


func _ready() -> void:
    enabled = false
    set_process(false)


func _process(_delta: float) -> void:
    global_position.x = _target.global_position.x
    if !_ignore_y:
        global_position.y = _target.global_position.y


func _on_state_change(old: String, new: String) -> void:
    Logger.debug("CAMERA: %s -> %s" % [old, new])
