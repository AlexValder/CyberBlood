extends Interactable

@onready var _handle := $handle as Node2D


func interact() -> void:
    create_tween().tween_property(_handle, "rotation_degrees", 60, 0.75)\
        .set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

    interacted.emit()


func disable() -> void:
    _handle.rotation_degrees = 60
    $interactable/shape.disabled = true
    # to ensure the action was started
    interacted.emit()
