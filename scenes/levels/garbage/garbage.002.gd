extends BaseLevel

@onready var _boss_door := $env/static_body as StaticBody2D
@onready var _shadow_boss := $env/shadow as CanvasItem
@onready var _close_door := $env/close_door as Area2D
@onready var _shadow_wall := $env/shadow_hidden as CanvasItem
# todo: debug only
@onready var _fight_over_trigger := $env/bossfight_over as Area2D


func _ready() -> void:
    _shadow_boss.visible = true
    _shadow_wall.visible = true

    var boss = GameManager.save_data.get_map_change(biome, id, "rooteater_boss")
    if boss == "1":
        _boss_door.queue_free()
        _boss_door = null
        _close_door.queue_free()
        _close_door = null
        _shadow_boss.queue_free()
        _shadow_boss = null
        _fight_over_trigger.queue_free()
        _fight_over_trigger = null

    var wall = GameManager.save_data.get_map_change(biome, id, "hidden_passage")
    if wall == "1":
        _shadow_wall.queue_free()

    super._ready()


func _on_lever_interacted() -> void:
    if !is_instance_valid(_shadow_boss) || !is_instance_valid(_boss_door):
        return

    var tween := create_tween()
    tween.set_parallel()
    tween.tween_property(_shadow_boss, "modulate:a", 0.0, 1.5)
    tween.tween_callback(_shadow_boss.queue_free)
    tween.tween_property(_boss_door, "rotation", deg_to_rad(80), 1.5)
    tween.set_trans(Tween.TRANS_SPRING)
    tween.play()


func _on_entered_from_armory(body: Player) -> void:
    if body == null:
        return

    GameManager.save_data.push_map_change(biome, id, "hidden_passage", "1")
    _shadow_wall.queue_free()


func _on_boss_room_entered(body: Player) -> void:
    if body == null:
        return

    _close_door.queue_free()

    var tween := create_tween()
    tween.set_parallel()
    tween.tween_property(_boss_door, "rotation", 0, 0.5)
    tween.set_trans(Tween.TRANS_BOUNCE)
    tween.play()


func _on_bossfight_over() -> void:
    GameManager.save_data.push_map_change(biome, id, "rooteater_boss", "1")

    var key := Key.create_key("rooteater_key", Color.CRIMSON)
    key.global_position = $env/key_spawn.global_position
    $env.call_deferred("add_child", key)

    _boss_door.queue_free()
    _fight_over_trigger.queue_free()
