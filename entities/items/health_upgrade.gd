extends Pickup
class_name HealthUpgrade

const UPGRADE_BY := 10


func action(values: Dictionary) -> void:
    if values.body.has_method("increase_health"):
        values.body.increase_health(UPGRADE_BY)

    picked_up.emit()


func _on_body_entered(body: Player) -> void:
    if !body: return

    action({"body": body})
    self.queue_free()
