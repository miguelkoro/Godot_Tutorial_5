extends Node2D
const MENU = preload("uid://3p0mw7wkmfsa")
var counter_ref: Node
func _ready() -> void:
	#counter_ref = POINT_COUNTER.intanstiate()
	#add_child(counter_ref)
	
	pass
	
var current_player_points: int = 0

func add_points(points:int):
	current_player_points += points
	#current_ref.get_node("Label").text=str(current_player_points)
