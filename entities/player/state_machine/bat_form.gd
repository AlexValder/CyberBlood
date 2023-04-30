extends PlayerState
class_name BatFormState

@onready var _timer := $timer as Timer

var _can_shoot := true


func can_enter(dir: Dictionary) -> bool:
    if dir.has("prev") && (dir.prev as String).begins_with("bat_"):
        return true

    if !player.has_mana(Constants.BAT_FORM_COST):
        return false

    player.use_mana(Constants.BAT_FORM_COST)
    player.ensure_collision(player.PlayerForms.BAT)

    return true


func can_leave(dir: Dictionary) -> bool:
    assert(dir.has("next"))
    assert((dir.next as String) != null)

    if dir.next.begins_with("bat_"):
        # no problem for transforming between states
        return true

    if player.can_transform(player.PlayerForms.HUMAN):
        player.ensure_collision(player.PlayerForms.HUMAN)
        return true
    else:
        return false


func can_shoot() -> bool:
    return _can_shoot && player.has_mana(Constants.FIREBALL_COST)


func physics_process(_delta: float) -> void:
    if !_process: return

    if Input.is_action_just_pressed("change_form"):
        state_change.emit(self.name, "idle")

    if Input.is_action_just_pressed("melee") && can_shoot():
        _can_shoot = false
        player.use_mana(Constants.FIREBALL_COST)
        player.shoot_fireball()
        _timer.start()

    _check_horizontal_movement(player.FLY_SPEED)
    _check_vertical_movement(player.FLY_SPEED)

    player.move_and_slide()


func on_exit() -> void:
    super.on_exit()
    player.ensure_collision(player.PlayerForms.HUMAN)


func _on_timer_timeout() -> void:
    _can_shoot = true
