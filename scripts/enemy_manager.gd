extends Node

signal stop
signal resume

@onready var _keys := Constants.ENEMY_TYPE.keys()

var _enemies_no_spawn := {}


func _ready() -> void:
    for i in _keys.size():
        _keys[i] = _keys[i].to_lower()


func repopulate(level: BaseLevel) -> void:
    var children := level.enemies.get_children()
    for child in children:
        var spawner := child as EnemySpawner
        if spawner == null: continue

        spawner.spawn_enemy()


func get_enemy_path(value: Constants.ENEMY_TYPE) -> String:
    return "res://entities/enemies/{e}/{e}.tscn".format({"e" = _keys[value]})


## Loading enemy by its type value
## @type: type of the enemy
## @options: optional dictionary of properties that should be set for
## freshly loaded enemy
func load_enemy(type: Constants.ENEMY_TYPE, options := {}) -> BaseEnemy:
    var pck_scene := \
        load(EnemyManager.get_enemy_path(type)) as PackedScene
    var enemy := pck_scene.instantiate() as BaseEnemy
    enemy.add_to_group("enemies")

    EnemyManager.resume.connect(enemy.toggle_stop.bind(true))
    EnemyManager.stop.connect(enemy.toggle_stop.bind(false))

    for key in options:
        enemy.set(key, options[key])

    return enemy


func was_killed(level: String, spawner: String) -> bool:
    return _enemies_no_spawn.has(level)\
        && _enemies_no_spawn[level].has(spawner)


func push_killed(level: String, spawner: String) -> void:
    if !_enemies_no_spawn.has(level):
        _enemies_no_spawn[level] = []

    _enemies_no_spawn[level].push_back(spawner)


func clear_killed() -> void:
    _enemies_no_spawn.clear()
