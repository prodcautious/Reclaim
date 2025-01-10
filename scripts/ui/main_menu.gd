extends Control

@onready var play_button : Button = $CenterContainer/VBoxContainer/Play

#Play Button Handling
func _on_play_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")
	Global.game_controller.change_gui_scene("res://scenes/towns/town_1.tscn", false, true)

func _on_play_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_play_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

#Options Button Handling
func _on_options_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")

func _on_options_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_options_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")


#Quit Button Handling
func _on_quit_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")
	get_tree().quit()

func _on_quit_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_quit_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")


func set_focus_mode_by_platform() -> void:
	if OS.has_feature("console"):
		play_button.grab_focus()
	else:
		return
