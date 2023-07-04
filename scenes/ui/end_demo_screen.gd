extends Control


func _on_socials_button_up(url: String) -> void:
    OS.shell_open(url)
