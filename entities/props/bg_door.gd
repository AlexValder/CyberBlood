extends RoomTransitionTrigger
class_name BgDoor


func interact() -> void:
    GameManager.change_room(self)


func _ready() -> void:
    fromId = owner.name


func _on_body_entered(_node: Node2D) -> void:
    pass
