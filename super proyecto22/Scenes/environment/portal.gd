extends Node2D

var otroPortal

@export var grupo = 1 

var permiso = true:
	set(value):
		if permiso:
			$Timer.start()
		permiso = value
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var portals = get_tree().get_nodes_in_group("portal")
	for i in range (portals.size()):
		if portals[i].position != position:
			if portals[i].grupo == self.grupo:
				otroPortal = portals[i]
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_teletransport_area_entered(area):
	if area.get_parent().is_in_group("ninja") && permiso:
		area.get_parent().position = otroPortal.position
		otroPortal.permiso = false


func _on_timer_timeout():
	permiso = true
