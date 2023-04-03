extends BaseLevel


func get_extends() -> Vector4i:
    var limits := super.get_extends()
    limits.y -= 500
    return limits
