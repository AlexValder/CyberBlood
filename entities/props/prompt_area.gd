extends Area2D
class_name OneShotPrompt


@onready var _prompt := $prompt as ButtonPrompt
@export_range(0.1, 2.0, 0.1) var fade_in := 0.1
@export_range(0.1, 2.0, 0.1) var fade_out := 0.1

var _tween: Tween


func _on_player_entered() -> void:
    if is_instance_valid(_tween):
        _tween.kill()

    _tween = create_tween()
    _tween.tween_property(_prompt, "modulate:a", 1.0, 0.1)
    _tween.play()


func _on_player_exited() -> void:
    if is_instance_valid(_tween):
        _tween.kill()

    _tween = create_tween()
    _tween.tween_property(_prompt, "modulate:a", 0.0, 0.3)
    _tween.play()
