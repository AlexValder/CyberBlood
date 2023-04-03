extends Interactable
class_name Door

@export var opened_from_left := false
@export var opened_from_right := false


func interact() -> void:
    var player_pos := GameManager.player.global_position.x as int
    if opened_from_right && player_pos > self.global_position.x:
        queue_free()
    elif opened_from_left && player_pos < self.global_position.x:
        queue_free()

    interacted.emit()
