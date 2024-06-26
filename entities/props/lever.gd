extends Interactable
class_name Lever

@onready var _handle := $base/handle as Node2D


func interact() -> void:
    create_tween().tween_property(_handle, "rotation_degrees", 60, 0.75)\
        .set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

    interacted.emit()


func disable(emit := true) -> void:
    _handle.rotation_degrees = 60
    $shape.disabled = true
    # to ensure the action was started
    if emit:
        interacted.emit()
