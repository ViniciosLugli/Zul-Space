extends AudioStreamPlayer2D

const tracks = [
	'asteroid_hit1',
	'asteroid_hit2',
	'asteroid_hit3'
   ]

func _ready():
	pass

func play_dead():
	var audiostream = load('res://dataFile/xfx/losee.wav')
	set_stream(audiostream)
	play()

func play_random_song():
	randomize()
	var rand_nb = randi() % tracks.size()
	var audiostream = load('res://dataFile/xfx/' + tracks[rand_nb] + '.wav')
	set_stream(audiostream)
	play()
