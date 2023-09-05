extends HitBox
class_name FireBall

const RED_GRADIENT := "res://assets/textures/fireball_red.tres"
const BLUE_GRADIENT := "res://assets/textures/fireball_blue.tres"

@export var direction_movement := Vector2.RIGHT
@export var speed := 15.0

@onready var _polygon := $polygon2d as Polygon2D


static func spawn_fireball() -> FireBall:
    const path = "res://entities/projectiles/fireball.tscn"
    var fireball := (load(path) as PackedScene).instantiate() as FireBall
    return fireball


func make_enemy() -> void:
    damages_player = true
    damages_enemy = false
    _set_collision()
    _set_color()


func make_player() -> void:
    damages_player = false
    damages_enemy = true
    _set_collision()
    _set_color()


func reverse() -> void:
    damages_enemy = !damages_enemy
    damages_player = !damages_player
    _set_collision()
    _set_color()

    direction_movement *= -1


func _ready() -> void:
    super._ready()
    _set_collision()
    _set_color()


func _physics_process(_delta: float) -> void:
    self.position += direction_movement * speed


func _set_color() -> void:
    # TODO: more colors?
    if damages_player:
        _polygon.texture.gradient = load(RED_GRADIENT)
    elif damages_enemy:
        _polygon.texture.gradient = load(BLUE_GRADIENT)


func _set_collision() -> void:
    collision_layer = 0
    set_collision_mask_value(1, true)
    set_collision_mask_value(4, damages_player)
    set_collision_mask_value(5, damages_enemy)
    set_collision_mask_value(6, damages_player)
    set_collision_mask_value(7, damages_enemy)


func _on_body_entered(body: Node2D) -> void:
    if body.has_method("damage"):
        body.damage(damage)
    self.queue_free()


func _on_area_entered(area: Area2D) -> void:
    if area is HitBox:
        var hitbox := area as HitBox
        if hitbox.damages_enemy && damages_player \
        || hitbox.damages_player && damages_enemy:
            reverse()
    elif area is HurtBox:
        var hurtbox := area as HurtBox
        if hurtbox.damaged_by_enemy && damages_player \
        || hurtbox.damaged_by_player && damages_enemy \
        && hurtbox.owner.has_method("damage"):
            hurtbox.owner.damage(damage)
            self.queue_free()


func _on_life_timer_timeout() -> void:
    self.queue_free()
