extends Marker2D
class_name EnemySpawner

@export var enemy_type: Constants.ENEMY_TYPE
@export var options := {}
@export var always_spawn := false


func _ready() -> void:
    if always_spawn || !EnemyManager.was_killed(owner.name, self.name):
        spawn_enemy()


func spawn_enemy() -> void:
    var enemy := EnemyManager.load_enemy(enemy_type, options)
    enemy.enemy_died.connect(_on_enemy_died, CONNECT_ONE_SHOT)

    add_child(enemy)


func _on_enemy_died() -> void:
    if !always_spawn:
        EnemyManager.push_killed(owner.name, self.name)
