extends Interactable
class_name SavePoint

@onready var _timer := $timer as Timer

var _can_interact := true


func interact() -> void:
    if !_can_interact:
        return

    _can_interact = false
    GameManager.save_game()
    $save.color = Color.SPRING_GREEN
    GameManager.player.heal(GameManager.player.max_health)

    interacted.emit()
    _timer.start()


func _restore() -> void:
    $save.color = Color.from_string("002076", Color.RED)
    _can_interact = true
