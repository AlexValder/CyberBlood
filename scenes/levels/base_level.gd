extends Node2D
class_name BaseLevel

var spawnpoints: Array[Marker2D]


func get_extends() -> Vector4i:
    return Vector4i(0, 0, 500, 500)


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
