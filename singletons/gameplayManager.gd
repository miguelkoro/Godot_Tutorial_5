extends Node

var current_player_points: int = 0
func add_points(points: int):
	current_player_points += points
	print(current_player_points)
