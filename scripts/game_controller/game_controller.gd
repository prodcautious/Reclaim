class_name GameController extends Node

@export var world : Node2D
@export var gui : Control
@export var transition_controller : Control

var current_world_scene
var current_gui_scene

func _ready() -> void:
	Global.game_controller = self
	current_gui_scene = $GUI/SplashScreenManager

#Handle World Scene Changes
func change_world_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if delete:
		current_world_scene.queue_free()
	elif keep_running:
		current_world_scene.visible = false
	else:
		world.remove_child(current_world_scene)
	var new = load(new_scene).instantiate()
	world.add_child(new)
	current_world_scene = new

#Handle GUI Scene Changes
func change_gui_scene(
	new_scene: String,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
	) -> void:
	if transition:
		# Start with fade in to black
		transition_controller.transition(transition_in, seconds)
		await transition_controller.animation_player.animation_finished
		
	# While screen is black, swap the scenes
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
			
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	
	if transition:
		# Fade out from black to reveal new scene
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
