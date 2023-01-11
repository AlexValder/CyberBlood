extends Area2D

@export var food_spawner: Marker2D

const PICKUP_PATH := "res://entities/items/pickup.tscn"


func _on_body_entered(player: Player) -> void:
    if !player: return

    assert(food_spawner != null)

    var pickup := FoodPickup.get_pickup()
    pickup.global_position = food_spawner.global_position + Vector2.DOWN
    call_deferred("add_sibling", pickup)
