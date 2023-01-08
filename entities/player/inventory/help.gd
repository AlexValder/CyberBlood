extends Control


func _ready() -> void:
    self.visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("inv"):
        self.visible = !self.visible
        get_tree().paused = self.visible

        if self.visible:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
