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
        pickup.global_position = self.global_position
        pickup.global_position.x += randf_range(-5.0, 5.0)
        add_sibling(pickup)


func spawn_money(count: int) -> void:
    pass
    # TODO: implement money
