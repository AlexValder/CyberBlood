extends ProgressBar
class_name ValueBar

@onready var _value := $value as Label


func update() -> void:
    _value.text = str(int(self.value))


func set_max_value(new_value: int) -> void:
    var percentage = self.value / self.max_value
    self.max_value = new_value
    set_current_value(self.max_value * percentage)


func set_current_value(new_value: float) -> void:
    var tween := create_tween() as Tween
    tween.tween_method(
        _internal_set_value,
        self.value, new_value,
        1.0)


func _internal_set_value(new_value: float) -> void:
    self.value = new_value
    _value.text = str(int(new_value))

