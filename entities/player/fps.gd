extends Label


func _process(delta: float) -> void:
    self.text = "FPS: %d" % Engine.get_frames_per_second()
