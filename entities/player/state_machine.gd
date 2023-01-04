extends Node
class_name PlayerStateMachine

@onready var _player := self.get_parent() as Player
@onready var _current_state := $idle as PlayerState


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


func _on_state_change(_old_state: String, new_state: String) -> void:
    _player.update_status(new_state)
    _current_state.on_exit()
    _current_state = get_node(new_state)
    _current_state.on_entry()
