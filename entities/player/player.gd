extends CharacterBody2D
class_name Player

const GRAVITY := 320.0
const WALK_SPEED := 120.0
const JUMP := 210.0
const ACCEL := 0.1

@onready var _sprite := $sprite as AnimatedSprite2D


func play_anim(name: String, use_assert: bool = false) -> void:
    if use_assert:
        assert(_sprite.frames.has_animation(name), \
            "animation not found: %s" % name)

    _sprite.play(name)
