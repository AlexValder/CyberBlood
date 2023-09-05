extends BaseLevel


func get_extends() -> Vector4i:
    var vector := super.get_extends()
    vector[1] = -10_000
    vector[3] = 10_000

    return vector
