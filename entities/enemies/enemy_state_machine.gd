extends StateMachine
class_name EnemyStateMachine


func _on_skeleton_enemy_died() -> void:
    change_state("death")


func _on_skeleton_enemy_hurt() -> void:
    change_state("hurt")



