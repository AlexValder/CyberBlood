extends CharacterBody2D
class_name Player

const GRAVITY := 320.0
const WALK_SPEED := 120.0
const JUMP := 210.0
const ACCEL := 0.1

@onready var _sprite := $sprite as AnimatedSprite2D
@onready var _status := $GUI/status as Label


func play_anim(name: String, use_assert: bool = false) -> void:
    if use_assert:
        assert(_sprite.frames.has_animation(name), \
            "animation not found: %s" % name)

    _sprite.play(name)


func ensure_collision(form: String) -> void:
    match (form):
        "human":
            $shape_human.set_deferred("disabled", false)
            $shape_bat.set_deferred("disabled", true)
        "bat":
            $shape_human.set_deferred("disabled", true)
            $shape_bat.set_deferred("disabled", false)
        _:
            push_error("Unknown form: %s" % form)


func update_status(status: String) -> void:
    _status.text = status
