extends AudioStreamPlayer


const tracks = [
	'power_up',
	'power_up1',
	'power_up2'
   ]

func _ready():
	  pass

func play_random_song():
	randomize()
	var rand_nb = randi() % tracks.size()
	var audiostream = load('res://dataFile/xfx/' + tracks[rand_nb] + '.wav')
	set_stream(audiostream)
	play()
