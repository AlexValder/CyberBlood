extends Area2D
class_name HurtBox

@export var damaged_by_player := false
@export var damaged_by_enemy := true
@export var custom_owner: Node

@onready var shape := $shape as CollisionShape2D
@onready var _timer := $timer as Timer

var _last_hitbox: HitBox = null


func _init() -> void:
    var timer := Timer.new()
    timer.name = "timer"
    timer.one_shot = false
    timer.wait_time = 0.1
    timer.timeout.connect(_take_damage, CONNECT_PERSIST)
    self.add_child(timer)


func _ready() -> void:
    self.set_collision_layer_value(4, damaged_by_enemy)
    self.set_collision_layer_value(5, damaged_by_player)
    self.set_collision_mask_value(6, damaged_by_player)
    self.set_collision_mask_value(7, damaged_by_enemy)

    self.area_entered.connect(_on_area_entered, CONNECT_PERSIST)
    self.area_exited.connect(_on_area_exited, CONNECT_PERSIST)


func _on_area_entered(area: Area2D) -> void:
    var hitbox := area as HitBox
    if hitbox == null:
        return

    var wr = weakref(hitbox)
    if (!wr.get_ref()):
        return

    var can_damage = damaged_by_enemy && hitbox.damages_player \
        || damaged_by_player && hitbox.damages_enemy

    if !can_damage:
        return

    _last_hitbox = hitbox
    _take_damage()
    if damaged_by_enemy && hitbox is LastingHitBox:
        var interval := (hitbox as LastingHitBox).damage_interval
        _timer.start(interval)


func _on_area_exited(area: Area2D) -> void:
    var hitbox := area as HitBox
    if hitbox == null:
        return

    _last_hitbox = null
    _timer.stop()


func _take_damage() -> void:
    if _last_hitbox == null:
        push_warning("No last hitbox")
        return

    var actor := self.owner if custom_owner == null else custom_owner
    if actor.has_method("damage"):
        actor.damage(_last_hitbox.damage)
    else:
        push_warning("owner %s can't be damaged" % actor.name)
