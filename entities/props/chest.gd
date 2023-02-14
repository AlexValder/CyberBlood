extends Interactable

@export var contains: Dictionary = {
    "food": 0,
    "money": 0,
    "special": {},
}


func interact() -> void:
    $interactable/shape.disabled = true
    $anim_player.play("open")

    if contains.food > 0:
        spawn_food(contains.food)

    if contains.money > 0:
        spawn_money(contains.money)

    # TODO: special items??

    interacted.emit()


func disable() -> void:
    $interactable/shape.disabled = true
    $anim_player.play("open")
    $anim_player.seek($anim_player.current_animation_length, true)


func spawn_food(count: int) -> void:
    for i in count:
        var pickup := FoodPickup.get_pickup()
        add_sibling(pickup)
        pickup.global_position = self.global_position
        pickup.apply_central_impulse(
            Vector2(randf_range(-150.0, 150.0), -150.0))


func spawn_money(count: int) -> void:
    var pickups := MoneyPickup.get_pickup(count)
    for pickup in pickups:
        add_sibling(pickup)
        pickup.global_position = self.global_position
        pickup.apply_central_impulse(
            Vector2(randf_range(-150.0, 150.0), -150.0))
