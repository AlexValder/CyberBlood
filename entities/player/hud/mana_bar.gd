extends LabeledValueBar
class_name ManaBar


func _on_player_mana_changed(new_value: int) -> void:
    set_current_value(new_value)
