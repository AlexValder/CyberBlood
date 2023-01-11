extends LabeledValueBar
class_name ManaBar


func _on_player_mana_spent(new_value: int) -> void:
    set_current_value(new_value)


func _on_recovery_value_timeout(rate: float) -> void:
    if self.value < self.max_value:
        set_current_value(self.value + rate)
