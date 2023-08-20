extends Node

const ICON_PATHS := "res://assets/gui/icons/inputs/{platform}/{button}.png"
enum PromptStyle {
    Keyboard,
    Xbox,
    Playstation,
    Switch,
}

var prompt_style := PromptStyle.Keyboard
var _is_joy_connected := false


func get_button_path(action: String) -> String:
    # get action

    return ICON_PATHS.format({
        "platform" = get_folder(prompt_style),
        "button" = get_button(action)})


func get_folder(prompt: PromptStyle) -> String:
    match prompt:
        PromptStyle.Keyboard:
            return "keyboard"
        PromptStyle.Xbox:
            return "xbox"
        PromptStyle.Playstation:
            return "playstation"
        PromptStyle.Switch:
            return "switch"
    return "keyboard"


func get_button(action: String) -> String:
    assert(InputMap.has_action(action))

    var events := InputMap.action_get_events(action)

    for event in events:
        if prompt_style == PromptStyle.Keyboard && _is_keyboard(event):
            if event is InputEventKey:
                var e := event as InputEventKey
                return _get_keycode(e.physical_keycode)
            else:
                var e := event as InputEventMouse
                print(e.as_text())
                return e.as_text()
        elif _is_joy_connected && _is_controller(event):
            break
    return ""


func _ready() -> void:
    _check_if_joy_connected()
    Input.joy_connection_changed.connect(_on_joy_connected)


func _input(event: InputEvent) -> void:
    if _is_keyboard(event):
        prompt_style = PromptStyle.Keyboard
    else:
        # TODO: custom controller prompt
        prompt_style = PromptStyle.Xbox


func _on_joy_connected(device_id: int, connected: bool) -> void:
    Logger.debug("Device %d was %s" %
        [device_id, "connected" if connected else "disconnected"])

    if connected:
        _is_joy_connected = true
    else:
        _check_if_joy_connected()
        if !_is_joy_connected:
            prompt_style = PromptStyle.Keyboard


func _check_if_joy_connected() -> void:
    _is_joy_connected = !Input.get_connected_joypads().is_empty()


func _is_keyboard(event: InputEvent) -> bool:
    return event is InputEventKey or event is InputEventMouse


func _is_controller(event: InputEvent) -> bool:
    return event is InputEventJoypadButton or event is InputEventJoypadMotion


func _get_keycode(keycode: int) -> String:
    match keycode:
        KEY_BRACKETLEFT:
            return "bracket_left"
        KEY_BRACKETRIGHT:
            return "bracket_right"
        _:
            return OS.get_keycode_string(keycode).to_lower()
