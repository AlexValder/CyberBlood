extends EnemyStateMachine


func _on_owner_ready() -> void:
    super._on_owner_ready()

    if !owner.awake:
        return

    if _current_state != null:
        _current_state.on_exit()
    _current_state = $awoke
    if _status != null:
        _status.text = _current_state.name
    _current_state.on_entry()
