extends LabeledValueBar
class_name ManaBar


func _on_player_mana_changed(new_value: int) -> void:
    set_current_value(new_value)


func _on_recovery_value_timeout(rate: float) -> void:
    set_current_value(min(self.value + rate, self.max_value))
