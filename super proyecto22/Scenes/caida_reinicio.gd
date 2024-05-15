extends Area2D

@export var inicio:PackedScene


func _on_body_entered(body):
	get_tree().reload_current_scene()
