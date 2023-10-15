extends Marker2D
class_name CameraTarget

const CAMERA_VERTICAL_SHIFT := 400.0
const CAMERA_HORIZONTAL_SHIFT := 500.0
const MOUSE_VERTICAL_SHIFT := 100.0/2
const MOUSE_HORIZONTAL_SHIFT := 125.0/2

var _shift := Vector2.ZERO
var _mouse_used := false


func _input(event: InputEvent) -> void:
    # TODO: fix junkiness
    if event.is_action_pressed("camera_toggle"):
        _mouse_used = true
    elif event.is_action_released("camera_toggle"):
        _mouse_used = false

    if _mouse_used:
        var e := event as InputEventMouseMotion
        if e == null:
            return

        print("e.relative = " + str(e.relative))
        print("_shift = " + str(_shift))

        if !is_zero_approx(e.relative.x):
            _shift.x = clampf(
                e.relative.x * MOUSE_HORIZONTAL_SHIFT,
                -CAMERA_HORIZONTAL_SHIFT, CAMERA_HORIZONTAL_SHIFT)
        if !is_zero_approx(e.relative.y):
            _shift.y = clampf(
                e.relative.y * MOUSE_VERTICAL_SHIFT,
                -CAMERA_VERTICAL_SHIFT, CAMERA_VERTICAL_SHIFT)
    else:
        _shift = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
    if !_mouse_used:
        var shift := Input.get_vector(
            "camera_left", "camera_right", "camera_up", "camera_down")
        _shift.x = shift.x * CAMERA_HORIZONTAL_SHIFT
        _shift.y = shift.y * CAMERA_VERTICAL_SHIFT


func get_target_position() -> Vector2:
    return global_position + _shift
