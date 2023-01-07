extends Node


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
            get_tree().paused = true
            print("Paused")
        NOTIFICATION_APPLICATION_FOCUS_IN:
            get_tree().paused = false
            print("Unpaused")
