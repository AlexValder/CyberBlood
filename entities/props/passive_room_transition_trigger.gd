extends RoomTransitionTrigger
class_name BgDoor


@onready var _prompt := $"prompt" as ButtonPrompt

var _tween: Tween


func interact() -> void:
    GameManager.change_room(self)


func _ready() -> void:
    fromId = owner.name


func _on_body_entered(_node: Node2D) -> void:
    if is_instance_valid(_tween):
        _tween.kill()

    _tween = create_tween()
    _tween.tween_property(_prompt, "modulate:a", 1.0, 0.1)
    _tween.play()


func _on_body_exited(_node: Node2D) -> void:
    if is_instance_valid(_tween):
        _tween.kill()

    _tween = create_tween()
    _tween.tween_property(_prompt, "modulate:a", 0.0, 0.3)
    _tween.play()
