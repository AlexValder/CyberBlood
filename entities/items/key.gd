extends Pickup
class_name Key

@export var key_id := ""
@export_color_no_alpha var color_hint := Color.WHITE


func _ready() -> void:
    $anim.play("idle")
    _sprite.self_modulate = color_hint


func _on_body_entered(body: Player) -> void:
    if body == null:
        return

    Logger.debug("Player touched key: %s" % key_id)
    body.add_item_to_inv(key_id)
    picked_up.emit()
    queue_free()
