import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_runner/views/player_controls.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key, required this.song});
  final SongModel song;
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late Duration max_position = Duration(milliseconds: widget.song.duration!);

  @override
  Widget build(BuildContext context) {
    print(widget.song.duration);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.red,

                ),
                SizedBox(
                  width: 10,
                  height: 10,
                ),
                Text(
                  widget.song.title,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.song.artist != null ? widget.song.artist! : "Unknown",
                  style: TextStyle(fontSize: 16),
                ),
                ProgressBar(progress: duration, total: max_position), // TODO: Add a streambuilder to update audio
                Controls(player: audioPlayer)
              ],
            )),
      ),
    );
  }
}
