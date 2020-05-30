extends Node

export (PackedScene) var Mob

var score

func _ready():
    randomize()


func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()

    $HUD.show_game_over()

    $Music.stop()
    $DeathSound.play()

func new_game():
    get_tree().call_group("mobs", "queue_free")

    score = 0
    $Player.start($StartPosition.position)
    $StartTimer.start()

    $HUD.update_score(score)
    $HUD.show_message("Get Ready")

    $Music.play()


func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.offset = randi()

    # Create a Mob instance and add it to the scene.
    var mob = Mob.instance()
    var mob_sprite = mob.get_node("AnimatedSprite")
    var mob_collision = mob.get_node("CollisionShape2D")

    add_child(mob)

    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position

    if (randi() % 10 == 0):
        mob_sprite.modulate = Color(1, 0, 0)

        mob.rotation = mob.get_angle_to($Player.position)

        mob.linear_velocity = Vector2(mob.angry_speed, 0)
    else:
        # Set the mob's direction perpendicular to the path direction.
        var direction = $MobPath/MobSpawnLocation.rotation + PI / 2

        # Add some randomness to the direction.
        direction += rand_range(-PI / 4, PI / 4)
        mob.rotation = direction

        if (randi() % 20 == 0):
            mob_sprite.modulate = Color(0, 1, 0)
            mob_sprite.scale = mob_sprite.scale * 2
            mob_collision.scale = mob_collision.scale * 2
            mob.linear_velocity = Vector2(mob.giant_speed, 0)
        else:
            mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)

    mob.linear_velocity = mob.linear_velocity.rotated(mob.rotation)


func _on_ScoreTimer_timeout():
    score += 1
    $HUD.update_score(score)


func _on_StartTimer_timeout():
    $MobTimer.start()
    $ScoreTimer.start()
