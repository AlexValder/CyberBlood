extends Breakable


func action_on_break() -> void:
    var pickup := FoodPickup.get_pickup()
    pickup.global_position = $sprite/sprite.global_position
    call_deferred("add_sibling", pickup)
