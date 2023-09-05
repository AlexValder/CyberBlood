extends BaseLevel


func _on_heal_body_entered(player: Player) -> void:
    if player == null:
        return

    player.heal(10_000_000_000)


func _on_mana_body_entered(player: Player) -> void:
    if player == null:
        return

    player.give_mana(10_000_000_000)
