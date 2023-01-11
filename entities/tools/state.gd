extends Node
class_name State

signal state_change(old_state, new_state)


func on_entry() -> void:
    if self.owner.has_method("play_anim"):
        self.owner.play_anim(self.name)


func on_exit() -> void:
    pass


func can_enter(_dir: Dictionary) -> bool:
    return true


func can_leave() -> bool:
    return true


func process(_delta: float) -> void:
    pass


func physics_process(_delta: float) -> void:
    pass
