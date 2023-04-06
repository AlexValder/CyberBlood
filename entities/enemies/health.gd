extends ValueBar


func _on_enemy_damaged(_old_value: float, new_value: float) -> void:
    set_current_value(new_value)
