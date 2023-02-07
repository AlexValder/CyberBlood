extends Node2D
class_name Breakable

@onready var _anim_player := $anim_player as AnimationPlayer
@export_range(1, 20) var required_hits := 1


func _ready() -> void:
    play_anim("RESET")


func action_on_break() -> void:
    Logger.debug("Broke %s" % get_parent().name)


func play_anim(anim: String) -> void:
    _anim_player.stop()

    if _anim_player.has_animation(anim):
        _anim_player.play(anim)


func damage(_value: int) -> void:
    required_hits -= 1


func _on_break(body: Node2D) -> void:
    Logger.debug("[%s] Hits left: %d" % [get_parent().name, required_hits])
    if required_hits <= 0:
        play_anim("on_break")
        action_on_break()
        queue_free()
    else:
        play_anim("on_hit")
