extends Node2D
class_name Breakable

@onready var _anim_player := $anim_player as AnimationPlayer
@export_range(1, 20) var required_hits := 1
@export var has_health := false
@export var health := 10


func _ready() -> void:
    play_anim("RESET")


func action_on_break() -> void:
    Logger.debug("Broke %s" % get_parent().name)


func play_anim(anim: String) -> bool:
    _anim_player.stop()

    if _anim_player.has_animation(anim):
        _anim_player.play(anim)
        return true
    return false


func damage(value: int) -> void:
    if has_health:
        health -= value
    else:
        required_hits -= 1

    if required_hits <= 0 or health <= 0:
        Logger.debug("[%s] Destroyed" % self.name)
        self_break()
    else:
        Logger.debug("[%s] Hits left: %d" % [self.name, required_hits])
        play_anim("on_hit")


func self_break() -> void:
    action_on_break()
    if play_anim("on_hit"):
        _anim_player.animation_finished.connect(func(_p): queue_free())
    else:
        queue_free()
