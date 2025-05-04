extends Node

@export var mob_scene: PackedScene
var score
var is_game_over = false

func _ready():
	is_game_over = false
	pass # Game only starts on button click

func _on_start_button_pressed():
	new_game()
	$HUD.hide_start_button()

func game_over():
	is_game_over = true
	$ScoreTimer.stop()
	$MobTimer.stop()
	$StartTimer.stop()
	$HUD.set_start_button_text("Try Again")
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$Player.set_process(false)


func new_game():
	is_game_over = false
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$Player.set_process(true)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_score_timer_timeout():
	if is_game_over:
		return
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	if is_game_over:
		return
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	if is_game_over:
		return

	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
