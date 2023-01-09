extends CharacterBody2D
class_name BaseEnemy

@onready var _sprite := $sprite as AnimatedSprite2D
@onready var _player := GameManager.player


func _process(_delta: float) -> void:
    _sprite.flip_h = _player.global_position.x < self.global_position.x
