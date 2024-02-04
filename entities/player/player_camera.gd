extends Camera2D
class_name PlayerCamera

var player: Player
var _target: CameraTarget
var _ignore_y := false

@onready var _timer := $timer as Timer
@onready var _label := $canvas/label as RichTextLabel

######
# PUBLIC METHODS
######

## Set camera limits. Order of values in `vec`: left, top, right, bottom.
func set_limits(vec: Vector4i) -> void:
    limit_left = vec[0]
    limit_top = vec[1]
    limit_right = vec[2]
    limit_bottom = vec[3]

## Configure player, his signals and values. Error if player was not set.
func setup_player() -> void:
    player.state_machine.state_transition.connect(_on_state_change)
    _target = player.get_node("areas/camera_target") as CameraTarget
    assert(_target != null)
    global_position = _target.get_target_position()

######
# PRIVATE METHODS
######

func _ready() -> void:
    enabled = false
    set_process(false)


func _process(_delta: float) -> void:
    global_position.x = _target.get_target_position().x
    if !_ignore_y:
        global_position.y = _target.get_target_position().y


func _on_state_change(old: String, new: String) -> void:
    Logger.debug("CAMERA: %s -> %s" % [old, new])
    match new:
        "jump", "double_jump":
            _toggle_ignore_y(true)
        "idle":
            pass
        "fall", "double_fall":
            _start_restore_timer(1.5)
        _:
            _timer.stop()
            _toggle_ignore_y(false)


func _toggle_ignore_y(new_ignore_y: bool) -> void:
    _label.text = "Camera Y: " + ("[color=green]TRUE[/color]" if !new_ignore_y\
        else "[color=red]FALSE[/color]")
    _ignore_y = new_ignore_y


func _start_restore_timer(duration: float) -> void:
    _timer.start(duration)
