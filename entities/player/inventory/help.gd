extends TabContainer


func _enter_tree() -> void:
    self.visible = false


func _unhandled_input(event: InputEvent) -> void:
    var tab_change := false

    if event.is_action_pressed("inv"):
        self.visible = !self.visible
        get_tree().paused = self.visible

        if self.visible:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    elif event.is_action_pressed("ui_right_tab"):
        tab_change = true
        if self.current_tab == self.get_child_count() - 1:
            self.current_tab = 0
        else:
            self.current_tab += 1
    elif event.is_action_pressed("ui_left_tab"):
        tab_change = true
        if self.current_tab == 0:
            self.current_tab = self.get_child_count() - 1
        else:
            self.current_tab -= 1

    if tab_change:
        var tab := self.get_child(self.current_tab) as InventoryTab
        if tab != null:
            tab.set_gamepad_focus()
