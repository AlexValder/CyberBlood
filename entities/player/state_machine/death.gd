extends PlayerState


func on_entry() -> void:
    super.on_entry()
    player.velocity = Vector2.ZERO
