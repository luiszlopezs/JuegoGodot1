extends Node2D

#tamaño de cada anillo: 6 px

var floorDetected = false
var safeTimeOut = false
var rayCastInitValue = 36 #pixeles iniciales raycast
# Called when the node enters the scene tree for the first time.
func _ready():
	$raycast_floor_detection.target_position.y = rayCastInitValue
	$safeTime.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not floorDetected && safeTimeOut:
		$raycast_floor_detection.target_position.y +=6
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 6
			init_spikeball()
	
	$SpikeBall.rotation = self.rotation
			

func init_spikeball():
	var numberOfChains = ($raycast_floor_detection.target_position.y - rayCastInitValue) / 6
	$SpikeBall.position.y += (numberOfChains * 6)
	for i in range(numberOfChains):
		var newRing = preload("res://Scenes/Enemies/One_chain.tscn").instantiate()
		newRing.position = Vector2(0,(6*(i+1)))
		self.add_child(newRing)
	
	$animation_rotation.play("regular_move")
	
	


func _on_safe_time_timeout():
	safeTimeOut = true


func _on_area_collision_with_map_body_entered(body):
	$animation_rotation.speed_scale *= -1
