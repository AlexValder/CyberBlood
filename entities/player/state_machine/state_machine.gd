extends Node2D
class_name PlayerStateMachine

@onready var _player := self.get_parent() as Player
@onready var _current_state := $idle as PlayerState


func reset() -> void:
    var state := $idle
    _player.update_status(state.name)
    _current_state.on_exit()
    _current_state = state
    _current_state.on_entry()


func _ready() -> void:
    self.top_level = true


func _on_player_ready():
    for child in get_children():
        var player_state = child as PlayerState
        player_state.player = _player
        player_state.state_change.connect(_on_state_change)

    _current_state.on_entry()
    _player.update_status(_current_state.name)


func _physics_process(delta: float) -> void:
    _current_state.physics_process(delta)


func _on_state_change(old_state: String, new_state: String) -> void:
    var state := get_node(new_state) as PlayerState
    if state == null || !state.can_enter({"prev" = old_state}):
        return

    if !_current_state.can_leave():
        return

    _player.update_status(new_state)
    _current_state.on_exit()
    _current_state = state
    _current_state.on_entry()


func _on_player_dead() -> void:
    change_state("death")


func _on_player_damaged() -> void:
    change_state("hurt")


func change_state(state_name: String) -> void:
    var state := get_node(state_name) as PlayerState

    _player.update_status(state.name)
    _current_state.on_exit()
    _current_state = state
    _current_state.on_entry()
