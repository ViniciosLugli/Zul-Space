extends Camera2D

func asteroid_exploded():
	$Screenshake.start(1, 15, 10, 2)

func on_Player_laser_shoot():
	$Screenshake.start(0.1, 15, 2, 0)

func on_Player_hit():
	$Screenshake.start(0.5, 15, 2, 0)
