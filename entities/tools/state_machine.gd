extends Node2D
class_name StateMachine

@onready var _current_state := $idle as State
@onready var _status := $status as Label


func reset() -> void:
    var state := $idle
    _current_state.on_exit()
    _current_state = state
    _current_state.on_entry()


func change_state(state_name: String) -> void:
    _on_state_change(_current_state.name, state_name)


func _init() -> void:
    var label := Label.new()
    label.name = "status"
    label.position.y = 20
    label.grow_horizontal = Control.GROW_DIRECTION_BOTH
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.label_settings = LabelSettings.new()
    label.label_settings.outline_size = 2
    label.label_settings.outline_color = Color.BLACK
    label.theme = load("res://assets/gui/themes/default.tres")
    add_child(label)


func _ready() -> void:
    self.owner.ready.connect(_on_owner_ready, CONNECT_ONE_SHOT)


func _on_owner_ready() -> void:
    for child in get_children():
        var state = child as State
        if !state: continue

        state.state_change.connect(_on_state_change)

    _current_state = $idle
    _status.text = _current_state.name
    _current_state.on_entry()


func _process(delta: float) -> void:
    _current_state.process(delta)


func _physics_process(delta: float) -> void:
    _current_state.physics_process(delta)


func _on_state_change(old_state: String, new_state: String) -> void:
    var state := get_node_or_null(new_state) as State
    if state == null || !state.can_enter({"prev" = old_state}):
        return

    if !_current_state.can_leave({"next" = state.name}):
        return

    _status.text = state.name
    _current_state.on_exit()
    _current_state = state
    _current_state.on_entry()
