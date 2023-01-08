extends Node

var _prev_state := false


func reload_level() -> void:
    get_tree().reload_current_scene()


func _ready() -> void:
    self.process_mode = Node.PROCESS_MODE_ALWAYS
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        get_tree().quit(0)


func _notification(what: int) -> void:
    match (what):
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            _prev_state = get_tree().paused
            get_tree().paused = true
        NOTIFICATION_APPLICATION_FOCUS_IN:
            get_tree().paused = _prev_state
