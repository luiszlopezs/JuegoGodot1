extends CanvasLayer

@onready var MenuPopUp : Node2D = $MenuPopUp
@export var inicio:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	MenuPopUp.visible = false
	if get_parent().has_node("ninja_frog"):
		$health_ProgressBar.value = get_parent().get_node("ninja_frog").health
		$fruitPointsLabel.text = "Fruit Points: " + str(get_parent().get_node("ninja_frog").fruitCount)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$health_ProgressBar.value = get_parent().get_node("ninja_frog").health
	$fruitPointsLabel.text = "Fruit Points: " + str(get_parent().get_node("ninja_frog").fruitCount)
	var currentTime = Time.get_time_dict_from_system()
	#if currentTime.minute < 10:
		#$clock.text = str(currentTime.hour) + ":0" + str(currentTime.minute)
	#else:
			#$clock.text = str(currentTime.hour) + ":" + str(currentTime.minute)


func _on_menu_button_pressed():
	get_tree().paused = true
	MenuPopUp.visible = get_tree().paused
	

#MENU POP UP
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	

func _on_sounds_pressed():
	pass # Replace with function body.


func _on_music_pressed():
	pass # Replace with function body.


func _on_resume_pressed():
	get_tree().paused = false
	MenuPopUp.visible = get_tree().paused


func _on_inicio_pressed():
	get_tree().change_scene_to_packed(inicio)
