extends Node2D

var velocidad = Vector2(450,-200)
var gravity = 9.8

signal shuriken_destroyed

var isFlip = false
	
func _ready():
	$Timer.start()
	if isFlip:
		velocidad.x *=-1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocidad.y += gravity
	position += velocidad * delta


func _on_hit_box_body_entered(body):
	$AnimationPlayer.stop()
	velocidad = Vector2(0,0)
	$shurikenSprite.play("die")

func _on_shuriken_sprite_animation_finished():
	destroy_myself()

func _on_timer_timeout():
	destroy_myself()
	
func destroy_myself():
	emit_signal("shuriken_destroyed")
	self.queue_free()
