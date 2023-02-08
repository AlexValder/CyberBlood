extends ValueBar
class_name LabeledValueBar

@onready var _value := $value as Label


func increase_max(to: float) -> void:
    if self.value > to:
        set_current_value(self.max_value + to)
    self.max_value = to


func update() -> void:
    _value.text = str(int(self.value))


func _internal_set_value(new_value: float) -> void:
    self.value = new_value
    _value.text = str(int(new_value))
