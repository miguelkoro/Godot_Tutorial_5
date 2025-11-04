extends Area2D



func _on_body_entered(body: Node2D) -> void:
	GameplayManager.add_points(5)
