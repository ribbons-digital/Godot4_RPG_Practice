extends Node


var player_current_attack = false

var current_scene = "world"
var is_in_transition_scene = false

var player_exit_cliff_side_pos_x = 0
var player_exit_cliff_side_pos_y = 0
var player_start_pos_x = 0
var player_start_pos_y = 0


func finish_change_scene():
	if is_in_transition_scene == true:
		is_in_transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
