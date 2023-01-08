extends Label


func _process(_delta: float) -> void:
    self.text = "FPS: %d" % Engine.get_frames_per_second()


func _on_fps_toggled(button_pressed: bool) -> void:
    self.set_process(button_pressed)
    self.visible = button_pressed
