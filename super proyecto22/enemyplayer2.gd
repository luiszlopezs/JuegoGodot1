extends CharacterBody2D

const SPEED = 200
const RAY_FLOOR_POSITION_X = 20
const RAY_WALL_TARGET_POSITION_X = 20
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x = SPEED
	$raycast_floor_detection.position.x = RAY_FLOOR_POSITION_X
	$raycast_wall_detection.target_position.x = RAY_WALL_TARGET_POSITION_X

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not $raycast_floor_detection.is_colliding() || $raycast_wall_detection.is_colliding():
		velocity.x *= -1
		# Ajusta la posición de los rayos para que estén en el lado opuesto.
		if velocity.x > 0:
			$raycast_floor_detection.position.x = RAY_FLOOR_POSITION_X
			$raycast_wall_detection.target_position.x = RAY_WALL_TARGET_POSITION_X
		else:
			$raycast_floor_detection.position.x = -RAY_FLOOR_POSITION_X
			$raycast_wall_detection.target_position.x = -RAY_WALL_TARGET_POSITION_X
		# Voltea el sprite horizontalmente.
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	
	move_and_slide()




func _on_damage_zone_area_entered(area):
	if area.is_in_group("shuriken"):
		velocity.x = 0
		$AnimatedSprite2D.play("die")
	
func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
