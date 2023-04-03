extends LabeledValueBar
class_name HealthBar


func _on_character_health_change(_old_value: int, new_value: int) -> void:
    if new_value > self.max_value:
        increase_max(new_value)
    set_current_value(new_value)
