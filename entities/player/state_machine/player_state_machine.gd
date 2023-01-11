extends StateMachine
class_name PlayerStateMachine


func _on_player_dead() -> void:
    change_state("death")


func _on_player_damaged() -> void:
    change_state("hurt")
