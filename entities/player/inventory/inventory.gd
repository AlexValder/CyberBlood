extends TabContainer


func _enter_tree() -> void:
    self.visible = false


func _unhandled_input(event: InputEvent) -> void:
    var tab_change := false

    if event.is_action_pressed("ui_cancel"):
        toggle()
    elif event.is_action_pressed("inv"):
        toggle()
    elif event.is_action_pressed("ui_right_tab"):
        if self.current_tab == self.get_child_count() - 1:
            self.current_tab = 0
        else:
            self.current_tab += 1
    elif event.is_action_pressed("ui_left_tab"):
        if self.current_tab == 0:
            self.current_tab = self.get_child_count() - 1
        else:
            self.current_tab -= 1


func _on_tab_changed(tabId: int) -> void:
    var tab := self.get_child(tabId) as InventoryTab
    if tab:
        tab.grab_gamepad_focus()


func toggle() -> void:
    self.visible = !self.visible
    get_tree().paused = self.visible

    if self.visible:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    else:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_visibility_changed() -> void:
    if self.visible:
        _on_tab_changed(self.current_tab)
