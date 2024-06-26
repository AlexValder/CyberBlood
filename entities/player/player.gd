extends CharacterBody2D
class_name Player

## Forms player can transform into.
enum PlayerForms {
    HUMAN,
    BAT,
    CAT,
}

signal player_dead
signal player_hurt
signal player_health_changed(old_value, new_value)
signal mana_changed(new_value)

## Used to pull player down.
const GRAVITY := 1050.0
## Used to limit player's vertical speed.
const GRAVITY_LIMIT := 700.0
const CAT_SPEED := 450.0
const WALK_SPEED := 390.0
## Ladder climbing speed
const CLIMB_SPEED := 270.0
const FLY_SPEED := 700.0
const JUMP := 752.5
const CAT_JUMP := 780.3
const ACCEL := 0.5

@onready var sprite := $sprite as AnimatedSprite2D
@onready var player_anim := $player_anim as AnimationPlayer
@onready var ladder_point := $areas/ladder_point as Node2D
@onready var state_machine := $state_machine as PlayerStateMachine
@onready var _shape := $shape as CollisionShape2D
@onready var _hurtbox := $areas/hurtbox as HurtBox
@onready var _selected_form := $"%selected_form" as Label
@onready var _money_bar = $"%money_bar"
@onready var _reach_area := $areas/reachable as Area2D
@onready var _climb_area := $areas/climb_area as Area2D
@onready var _jumpdown := $areas/jumpdown as Area2D
@onready var _firepoint := $areas/firepoint as Node2D

## Max possible health (can be increased).
@export var max_health: int = 50
## Max possible mana (can be increased).
@export var max_mana: float = 100.0

var current_health := max_health
var current_mana := max_mana
var money := 0
var mana_recovery_rate := 1.0
var flip := false:
    set(value):
        flip = value
        sprite.flip_h = value
        $areas.scale.x = -1 if value else 1
var _current_form := 0
var _forms := [
    PlayerForms.BAT,
    #PlayerForms.CAT, <- removing until improved
]
var inventory := []

######
# PUBLIC METHODS
######

## Call to cycle between available forms.
# You can only cycle in one direction.
func next_form() -> void:
    _current_form += 1
    if _current_form >= _forms.size():
        _current_form = 0

    _selected_form.text =\
        "selected form: %s" % PlayerForms.keys()[_forms[_current_form]]

## Returns default state name for the current form.
func tranform_name() -> String:
    match _forms[_current_form]:
        PlayerForms.BAT:
            return "bat_form"
        PlayerForms.CAT:
            return "cat_idle"

    push_error("Form unknown: %d" % _forms[_current_form])
    return "idle"

## Shoot fireball in bat form.
## TODO: more projectile types
func shoot_fireball() -> void:
    var fireball := FireBall.spawn_fireball()
    fireball.direction_movement = Vector2.LEFT if flip else Vector2.RIGHT
    fireball.speed = 6.5
    add_sibling(fireball)
    fireball.make_player()
    fireball.global_position = _firepoint.global_position

## Disables player's collision.
func disable_collision() -> void:
    if _shape != null:
        _shape.disabled = true
    collision_layer = 0

## Enables player's collision.
func enable_collision() -> void:
    if _shape != null:
        _shape.disabled = false
    collision_layer = 2

## Increase player's MAX health. Also completely heals the player.
func increase_health(by: int) -> void:
    max_health += by
    player_health_changed.emit(current_health, max_health)
    current_health = max_health

## Heals player, but not above maximum health.
func heal(value: int) -> void:
    player_health_changed.emit(
        current_health, min(max_health, current_health + value))
    current_health = min(max_health, current_health + value)

## Gain mana, but not above maximum mana.
func give_mana(value: int) -> void:
    mana_changed.emit(min(max_mana, current_mana + value))
    current_mana = min(max_mana, current_mana + value)

## Deal damage to the player.
func damage(value: int) -> void:
    if current_health <= 0:
        return

    if current_health > value:
        player_hurt.emit()

    player_health_changed.emit(current_health, max(0, current_health - value))
    current_health = max(0, current_health - value)

    if current_health <= 0:
        player_dies()

## Set money to a specific value.
func set_money(count: int) -> void:
    money = count
    _money_bar.set_money(count)

## Add number of money to current money.
func add_money(count: int) -> void:
    money += count
    _money_bar.add_money(count)

## Reduce number of money. NOTE: doesn't check if overdraw.
func spend_money(count: int) -> void:
    money -= count
    _money_bar.remove_money(count)

## Returns true if player can drop through the surface he stands on.
func can_drop_down() -> bool:
    if !is_on_floor(): return false

    return !_jumpdown.has_overlapping_areas()

## Start dropping down, will automatically call stop_drop_down.
func start_drop_down() -> void:
    Logger.debug("Starting drop down")
    set_collision_mask_value(9, false)
    ## HACK: re-enable after 0.5
    get_tree().create_timer(0.5, true, true)\
        .timeout.connect(stop_drop_down, CONNECT_ONE_SHOT)

## Stop dropping down, no need to call in general.
func stop_drop_down() -> void:
    Logger.debug("Stopping drop down")
    set_collision_mask_value(9, true)

## Call when player dies.
func player_dies() -> void:
    player_dead.emit()

## Return true, if player can tranform to `form`.
func can_transform(form: PlayerForms) -> bool:
    match form:
        PlayerForms.HUMAN:
            var metadata = get_meta("human_shape_size") as Vector2
            return _check_space(
                metadata.x,
                metadata.y
            )
        PlayerForms.BAT, PlayerForms.CAT:
            # the smallest form, no need to check for space
            return true

    return false

## Check if there is enough mana.
func has_mana(value: int) -> bool:
    return current_mana >= value

## Spend mana (error if not enough).
func use_mana(value: int) -> void:
    assert(has_mana(value))
    mana_changed.emit(current_mana - value)
    current_mana -= value

## Play animation with name `anim_name` from available libraries.
func play_anim(anim_name: String) -> void:
    player_anim.play("player/" + anim_name)

## Change player's collision shape based on `form`.
func ensure_collision(form: PlayerForms) -> void:
    var shape: Vector2
    var hurtbox: Vector2
    match form:
        PlayerForms.HUMAN:
            shape = get_meta("human_shape_size")
            hurtbox = get_meta("human_hurtbox_size")

        PlayerForms.BAT, PlayerForms.CAT:
            shape = get_meta("bat_shape_size")
            hurtbox = get_meta("bat_hurtbox_size")
        _:
            push_error("Unknown form: %s" % form)
            shape = Vector2.ZERO
            hurtbox = Vector2.ZERO

    _shape.shape.radius = shape.x * 2
    _shape.shape.height = shape.y * 2
    _hurtbox.shape.shape.radius = hurtbox.x
    _hurtbox.shape.shape.height = hurtbox.y

    velocity.y += 2
    move_and_slide()

## Get ladder player is currently on. Returns null, if not on a ladder.
func get_ladder() -> Ladder:
    var areas := _climb_area.get_overlapping_areas()
    for area in areas:
        if area is Ladder:
            return area as Ladder

    return null

## Adds `item` to inventory.
func add_item_to_inv(item: String) -> void:
    inventory.push_back(item)

## Removes `item` from inventory (error if not found).
func remove_item_to_inv(item: String) -> void:
    inventory.erase(item)

## Returns true if player has `item`.
func has_item_in_inv(item: String) -> bool:
    return inventory.has(item)

######
# PRIVATE METHODS
######

func _ready() -> void:
    var health_bar := $"%health_bar" as HealthBar
    health_bar.max_value = max_health
    health_bar.value = current_health
    health_bar.update()

    var mana_bar := $"%mana_bar" as ManaBar
    mana_bar.max_value = max_mana
    mana_bar.value = current_mana
    mana_bar.update()

    _money_bar.set_money(money)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("interact"):
        var areas := _reach_area.get_overlapping_areas()
        for area in areas:
            if area is Interactable:
                (area as Interactable).interact()
                return


func _on_recovery_value_timeout(rate: float) -> void:
    current_mana = min(max_mana, current_mana + rate)
    mana_changed.emit(current_mana)


func _check_space(h_space: float, v_space: float) -> bool:
    var horizontal: float
    var vertical: float

    # 1. Horizontal:
    # first check if we have twice the required size to the left
    # if not, remember how much we have and check the same to the right
    # sum of both has to be no less than required

    var space_state := get_world_2d().direct_space_state
    var params: = PhysicsRayQueryParameters2D.new()
    params.from = self.global_position
    params.to = self.global_position + Vector2(2 * h_space, 0)
    params.hit_from_inside = true
    params.exclude = [self.get_rid()]
    params.collision_mask = 0b1

    var result := space_state.intersect_ray(params)

    if result:
        horizontal = abs(self.global_position.x - result.position.x)
        params.to = self.global_position + Vector2(-2 * h_space, 0)
        result = space_state.intersect_ray(params)

        if result:
            horizontal += 1.0 * abs(result.position.x - self.global_position.x)
        else:
            horizontal += h_space * 2

        if horizontal < h_space * 2:
            # too narrow
            return false
    else:
        horizontal = h_space * 2

    # 2. Vertical:
    # first check if we have twice the required size upwards
    # if not, remember how much we have and check the same downwards
    # sum of both has to be no less than required

    params.to = self.global_position + Vector2(0, -2 * v_space)
    result = space_state.intersect_ray(params)

    if result:
        vertical = abs(self.global_position.y - result.position.y)
        params.to = self.global_position + Vector2(0, 2 * v_space)
        result = space_state.intersect_ray(params)

        if result:
            vertical += 1.0 * abs(result.position.y - self.global_position.y)
        else:
            vertical += v_space * 2

        if vertical < v_space * 2:
            # too short
            return false
    else:
        vertical = v_space * 2

    return vertical >= v_space * 2 && horizontal >= h_space * 2
