extends Node

signal input_changed

const ICON_PATHS := "res://assets/gui/icons/inputs/{platform}/{button}.png"
enum PromptStyle {
    Keyboard,
    Controller,
}

var prompt_style := PromptStyle.Keyboard
var _is_joy_connected := false


func get_button_path(action: String) -> String:
    assert(!action.contains("+"))
    return ICON_PATHS.format({
        "platform" = get_folder(prompt_style),
        "button" = get_button(action)})


func get_multiple_paths(action: String) -> PackedStringArray:
    assert(action.contains("+"))
    var actions := action.split("+", false)

    var buttons := [] as PackedStringArray
    for line in actions:
        buttons.push_back(get_button_path(line))

    return buttons


func get_folder(prompt: PromptStyle) -> String:
    match prompt:
        PromptStyle.Keyboard:
            return "keyboard"
        PromptStyle.Controller:
            var conf := Settings.get_game("controller_pref") as String
            if conf == "xbox" || conf == "switch" || conf == "playstation":
                return conf
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
                var e := event as InputEventMouseButton
                return _get_mouse(e.button_index)
        elif prompt_style == PromptStyle.Controller && _is_controller(event):
            if event is InputEventJoypadMotion:
                var e := event as InputEventJoypadMotion
                return _get_axis(e.axis, e.axis_value)
            else:
                var e := event as InputEventJoypadButton
                return _get_button(e.button_index)
    return ""


func change_style(style: String) -> void:
    assert(style == "xbox" || style == "playstation" || style == "switch")

    Settings.set_game("controller_pref", style)
    input_changed.emit()


func _ready() -> void:
    _check_if_joy_connected()
    Input.joy_connection_changed.connect(_on_joy_connected)


func _input(event: InputEvent) -> void:
    var old_style := prompt_style
    if _is_keyboard(event):
        prompt_style = PromptStyle.Keyboard
    else:
        prompt_style = PromptStyle.Controller

    if old_style != prompt_style:
        input_changed.emit()


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


func _get_mouse(button: int) -> String:
    match button:
        MouseButton.MOUSE_BUTTON_LEFT:
            return "lmb"
        MouseButton.MOUSE_BUTTON_RIGHT:
            return "rmb"
        MouseButton.MOUSE_BUTTON_MIDDLE:
            return "mmb"
        MouseButton.MOUSE_BUTTON_WHEEL_UP:
            return "wheel_up"
        MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
            return "wheel_down"
        _:
            return "mouse"


func _get_axis(axis: JoyAxis, value: float) -> String:
    match axis:
        JOY_AXIS_LEFT_X:
            if is_zero_approx(value):
                return "left_stick_h"
            elif value > 0:
                return "left_stick_right"
            else:
                return "left_stick_left"
        JOY_AXIS_RIGHT_X:
            if is_zero_approx(value):
                return "right_stick_h"
            elif value > 0:
                return "right_stick_right"
            else:
                return "right_stick_left"
        JOY_AXIS_LEFT_Y:
            if is_zero_approx(value):
                return "left_stick_v"
            elif value < 0:
                return "left_stick_up"
            else:
                return "left_stick_down"
        JOY_AXIS_RIGHT_Y:
            if is_zero_approx(value):
                return "right_stick_v"
            elif value < 0:
                return "right_stick_up"
            else:
                return "right_stick_down"
        JOY_AXIS_TRIGGER_LEFT:
            return "lt"
        JOY_AXIS_TRIGGER_RIGHT:
            return "rt"
    return ""


func _get_button(index: JoyButton) -> String:
    match index:
        JOY_BUTTON_A:
            return "a"
        JOY_BUTTON_B:
            return "b"
        JOY_BUTTON_X:
            return "x"
        JOY_BUTTON_Y:
            return "y"
        JOY_BUTTON_DPAD_DOWN:
            return "dpad_down"
        JOY_BUTTON_DPAD_LEFT:
            return "dpad_left"
        JOY_BUTTON_DPAD_RIGHT:
            return "dpad_right"
        JOY_BUTTON_DPAD_UP:
            return "dpad_up"
        JOY_BUTTON_START:
            return "system_right"
        JOY_BUTTON_BACK:
            return "system_left"
        JOY_BUTTON_RIGHT_SHOULDER:
            return "rb"
        JOY_BUTTON_LEFT_SHOULDER:
            return "lb"
        JOY_BUTTON_LEFT_STICK:
            return "l"
        JOY_BUTTON_RIGHT_STICK:
            return "r"
    return ""
