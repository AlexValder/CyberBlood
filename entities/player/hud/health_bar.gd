extends LabeledValueBar
class_name HealthBar


func _on_character_health_change(_old_value: int, new_value: int) -> void:
    set_current_value(new_value)
