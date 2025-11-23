extends Node


var BPM = 70.0
var BEAT_INTERVAL = 60.0 / BPM 
var FRAMES_PER_BEAT = 4        
var EIGHTH_INTERVAL = BEAT_INTERVAL / 2.0

var BEAT_WINDOW = 0.12

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

func is_on_beat() -> bool:
	var dist = min(time_since_last_beat, BEAT_INTERVAL - time_since_last_beat)
	return dist <= BEAT_WINDOW

func set_bpm(new_bpm: float) -> void:
	BPM = new_bpm
	BEAT_INTERVAL = 60.0 / BPM
	EIGHTH_INTERVAL = BEAT_INTERVAL / 2.0
	time_since_last_beat = 0.0
	time_since_last_eighth = 0.0
