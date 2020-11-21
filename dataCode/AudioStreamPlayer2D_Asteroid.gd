extends AudioStreamPlayer2D

const tracks = [
	'asteroid_explode1',
	'asteroid_explode2',
	'asteroid_explode3'
   ]
func _ready():
	randomize()
	play_random_song()

func play_random_song():
	randomize()
	set_stream(load('res://dataFile/xfx/' + tracks[randi() % tracks.size()] + '.wav'))
	play()
