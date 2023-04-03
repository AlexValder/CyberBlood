extends Control

@onready var _controls_popup := $controls as PopupPanel


func toggle() -> void:
    self.visible = !self.visible
    get_tree().paused = self.visible

    if self.visible:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    else:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
    _controls_popup.visible = false


func _on_popup_close_button_up(popup_name: String) -> void:
    var popup := get_node(popup_name) as Popup
    popup.hide()


func _on_popup_open_button_up(popup_name: String) -> void:
    var popup := get_node(popup_name) as Popup
    popup.popup_centered()


func _enter_tree() -> void:
    self.visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("inv"):
        toggle()
