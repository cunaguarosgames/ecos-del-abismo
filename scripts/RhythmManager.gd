extends Node


const BPM = 70.0
const BEAT_INTERVAL = 60.0 / BPM 
const FRAMES_PER_BEAT = 4        
const EIGHTH_INTERVAL = BEAT_INTERVAL / 2.0


signal beat_signal(beat_count)
signal eighth_signal(eighth_count)


var time_since_last_beat = 0.0
var time_since_last_eighth = 0.0
var beat_count = 0
var eighth_count = 0

func _process(delta):

	time_since_last_beat += delta
	if time_since_last_beat >= BEAT_INTERVAL:
		time_since_last_beat -= BEAT_INTERVAL 
		beat_count += 1
		emit_signal("beat_signal", beat_count)
		
	time_since_last_eighth += delta
	if time_since_last_eighth >= EIGHTH_INTERVAL:
		time_since_last_eighth -= EIGHTH_INTERVAL
		eighth_count += 1
		emit_signal("eighth_signal", eighth_count)

func start_music(audio_player_node: AudioStreamPlayer):
	audio_player_node.play()
	beat_count = 0
	eighth_count = 0
