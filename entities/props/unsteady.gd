extends StaticBody2D

@onready var _anim := $anim as AnimationPlayer
@onready var _sprite := $tilemap as Node2D


func _on_someone_standing(area: Node2D) -> void:
    if area == null:
        return

    _anim.play("destroy")
    var tween := create_tween()
    var initial := _sprite.position.y
    tween.tween_property(_sprite, "position:y", initial + 2, 0.06)
    tween.tween_property(_sprite, "position:y", initial - 2, 0.06)
    tween.tween_property(_sprite, "position:y", initial + 2, 0.06)
    tween.tween_property(_sprite, "position:y", initial, 0.06)
    tween.play()
