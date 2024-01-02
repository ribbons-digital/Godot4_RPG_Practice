extends CharacterBody2D

@export var speed = 45
var player_chase = false
var player = null

var health = 100
var is_player_in_attack_zone = false
var can_take_damage = true

func _physics_process(delta):
	if health > 0:
		handle_damage()
		update_health()
	
		if player_chase:
			position += (player.position - position)/speed
			$AnimatedSprite2D.play("walk")
		
			if player.position.x - position.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
	else:
		
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		self.queue_free()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false



func _on_enemy_hitbox_body_entered(body):
	if body.name == "player":
		is_player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.name == "player":
		is_player_in_attack_zone = false
		
func handle_damage():
	if is_player_in_attack_zone == true and Global.player_current_attack == true:
		if can_take_damage == true:
			health -= 20
			player_chase = false
			$damage_cooldown.start()
			$regen_timer.start()
			can_take_damage = false
			print("enemy health: ", health)
			


func _on_damage_cooldown_timeout():
	can_take_damage = true


func update_health():
	var health_bar = $health_bar
	health_bar.value = health
	
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true

func _on_regen_timer_timeout():
	if health < 100 and health > 0:
		health = health + 20
	if health > 100:
		health = 100.
