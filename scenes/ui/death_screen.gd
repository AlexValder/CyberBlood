extends CanvasLayer
class_name DeathScreen

signal death_screen_done

@onready var _anim := $root/anim_player as AnimationPlayer


func play() -> void:
    set_process_input(true)
    _anim.play("default")


func _ready() -> void:
    set_process_input(false)


func _input(event: InputEvent) -> void:
    if event.is_action_released("ui_cancel"):
        _anim.stop()
        get_tree().paused = false
        death_screen_done.emit()


func _on_anim_player_animation_finished(anim_name: String) -> void:
    if anim_name == "default":
        death_screen_done.emit()


func _on_death_screen_done() -> void:
    set_process_input(false)
