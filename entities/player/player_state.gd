extends Node
class_name PlayerState

signal state_change(old_state, new_state)

var player: Player = null


func on_entry() -> void:
    player.play_anim(self.name)


func on_exit() -> void:
    pass


func process(_delta: float) -> void:
    pass


func physics_process(_delta: float) -> void:
    pass
