extends PlayerState
class_name CatFormState


func can_leave(dir: Dictionary) -> bool:
    assert(dir.has("next"))
    assert((dir.next as String) != null)

    if dir.next.begins_with("cat_"):
        # no problem for transforming between states
        return true

    if player.can_transform(player.PlayerForms.HUMAN):
        player.ensure_collision(player.PlayerForms.HUMAN)
        return true
    else:
        return false
