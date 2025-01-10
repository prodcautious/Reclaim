class_name GameController extends Node

@export var world: Node2D
@export var gui: Control
@export var gui_camera : Camera2D
@export var transition_controller: Control
@export var player: CharacterBody2D

var current_world_scene
var current_gui_scene

var stored_player_state = {
	"position": Vector2.ZERO,
	"direction": Vector2.DOWN,
	"state": 0  # Corresponds to PlayerState.NORMAL
}

func _ready() -> void:
	Global.game_controller = self
	if gui.has_node("SplashScreenManager"):
		current_gui_scene = gui.get_node("SplashScreenManager")
		player.hide()

func change_world_scene(
	new_scene: String, 
	delete: bool = true, 
	keep_running: bool = false,
	spawn_id: String = "",  # Identifier for spawn point
	spawn_direction: Vector2 = Vector2.ZERO
) -> void:
	# Store player state before scene change
	if player:
		stored_player_state.direction = spawn_direction if spawn_direction != Vector2.ZERO else player.last_direction
		stored_player_state.state = player.current_state
		
	if delete:
		current_world_scene.queue_free()
	elif keep_running:
		current_world_scene.visible = false
	else:
		world.remove_child(current_world_scene)

	var new = load(new_scene).instantiate()
	world.add_child(new)
	current_world_scene = new
	gui_camera.queue_free()
	
	# Find spawn point in new scene
	if spawn_id:
		stored_player_state.position = _find_spawn_point(spawn_id)
	
	# Restore player state in new scene
	if player:
		player.position = stored_player_state.position
		player.last_direction = stored_player_state.direction
		player.current_state = stored_player_state.state
		_update_player_sprite_direction()

# Simplified spawn point finding using tilemap coordinates
func _find_spawn_point(spawn_id: String) -> Vector2:
	var spawn_points = current_world_scene.get_node_or_null("SpawnPoints")
	if spawn_points and spawn_points is TileMap:
		for cell_pos in spawn_points.get_used_cells(0):  # 0 is the layer number
			var data = spawn_points.get_cell_tile_data(0, cell_pos)
			if data and data.get_custom_data("spawn_id") == spawn_id:
				# Directly convert tile coordinates to local position
				return spawn_points.map_to_local(cell_pos)
	
	push_warning("No spawn point found for ID: " + spawn_id)
	return Vector2.ZERO

func change_gui_scene(
	new_scene: String,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0,
	hide_player: bool = true
) -> void:
	if transition:
		transition_controller.transition(transition_in, seconds)
		await transition_controller.animation_player.animation_finished
	
	if player and hide_player:
		player.visible = false
	
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

	if player and hide_player:
		player.visible = true

	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
		


# Updated to use AnimationPlayer instead of sprite animations
func _update_player_sprite_direction() -> void:
	if not player:
		return
		
	var anim_player = player.get_node_or_null("AnimationPlayer")
	if anim_player:
		var anim_name = "idle_"
		match player.last_direction:
			Vector2.DOWN:
				anim_name += "down"
			Vector2.UP:
				anim_name += "up"
			Vector2.LEFT:
				anim_name += "left"
			Vector2.RIGHT:
				anim_name += "right"
		
		if anim_player.has_animation(anim_name):
			anim_player.play(anim_name)
