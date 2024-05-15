extends CharacterBody2D

@export var packed_scene: PackedScene

const SPEED = 300.0
const JUMP_VELOCITY = GeneralRules.FrogJumpPower
var health = 100
var fruitCount = 0
var direction
var gotShuriken = false
var allow_animation:bool = false
var leaved_floor:bool = false
var had_jump:bool = false
var max_jump:int = 2
var count_jumps:int = 0
var double_jump:bool = false
var ray_cast_dimesion = 10.5
var stuck_on_wall:bool = false

@export var shuriken:PackedScene

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Animaciones.play("appear")
	$RayCast_walljump.target_position.x = ray_cast_dimesion

func _physics_process(delta):
	
	if is_on_floor():
		leaved_floor = false
		had_jump = false
		count_jumps = 0
		
	# Add the gravity.
	if not is_on_floor():
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and right_to_jump():
		if count_jumps ==1:
			double_jump=true
			$audioDoublejump.play()
		else:
			$audioJump.play()
		count_jumps+=1
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if $RayCast_walljump.get_collider():
		if $RayCast_walljump.get_collider().is_in_group("wall_jump"):
			if velocity.y > 0 :
				count_jumps = 0
				velocity.y = 0
				stuck_on_wall = true
		else: stuck_on_wall = false
	else: stuck_on_wall = false
	
	move_and_slide()
	decide_Animation()

func _input(event):
	if event.is_action_pressed("shuriken"):
		if gotShuriken:return
		gotShuriken = true
		allow_animation = false
		$Animaciones.play("shuriken_launch")
		var newShuriken = shuriken.instantiate()
		newShuriken.position = self.position
		newShuriken.isFlip = $Animaciones.flip_h
		newShuriken.connect("shuriken_destroyed", _on_shuri_destroyed)
		add_sibling(newShuriken)
		
func _on_shuri_destroyed():
	gotShuriken = false

func decide_Animation():
	
	if direction < 0:
		$Animaciones.flip_h = true
		$RayCast_walljump.target_position.x = -ray_cast_dimesion
	elif direction >0:
		$Animaciones.flip_h = false
		$RayCast_walljump.target_position.x = ray_cast_dimesion
	
	if double_jump:
		double_jump = false
		allow_animation = false

		$Animaciones.play("double_jump")
	
	if not allow_animation: return
	
	if stuck_on_wall:
		$Animaciones.play("wall_jump")
	else:
		if velocity.x == 0:
			$Animaciones.play("idle")
		elif velocity.x < 0 :
			$Animaciones.play("run")
		elif velocity.x > 0 :
			$Animaciones.play("run")
			
		if velocity.y > 0 :
			$Animaciones.play("jump_down")
		elif velocity.y < 0 :
			$Animaciones.play("jump_up")
		
	
func right_to_jump():
	if had_jump: 
		if count_jumps < max_jump: return true
		else: return false
	if is_on_floor() || stuck_on_wall:
		had_jump = true
		return true
	elif $coyote_timer.is_stopped():
		had_jump = true 
		return true


func collectFruit(fruitType):
	var auxString = fruitType + "Points"
	var gainedPoints = GeneralRules[auxString]
	fruitCount += gainedPoints
	$collect_coin.play()
	


func _on_animaciones_animation_finished():
	
		allow_animation = true


func _on_coyote_timer_timeout():
	
	pass # Replace with function body.


func _on_damage_detection_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	$audioDamage.play()
	allow_animation = false
	velocity.y = -250
	$Animaciones.play("hit")
	health -= 10
	if health <=0:
		allow_animation = false
		$Animaciones.play("total_die")
		velocity.y = 0
		$audioDamage.stop()
		$dead_total.play()
		$dead_timer.start()
		
		

func _on_dead_timer_timeout():
	get_tree().reload_current_scene()
