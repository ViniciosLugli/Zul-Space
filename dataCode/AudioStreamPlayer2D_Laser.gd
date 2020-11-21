extends AudioStreamPlayer2D

const tracks = [
	'player_shoot1',
	'player_shoot2',
	'LaserShoot'
   ]

func _ready():

	  play_random_song()

func play_random_song():
	randomize()
	var rand_nb = randi() % tracks.size()
	var audiostream = load('res://dataFile/xfx/' + tracks[rand_nb] + '.wav')
	set_stream(audiostream)
	play()
