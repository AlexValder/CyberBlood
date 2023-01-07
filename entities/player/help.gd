extends Control


func _ready() -> void:
    self.visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("help"):
        self.visible = !self.visible
