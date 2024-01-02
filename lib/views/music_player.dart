import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            color: Colors.red,
          ),
          Text(widget.song.title),
          Text(widget.song.artist != null ? widget.song.artist! : "Unknown"),
        ],
      ),
    );
  }
}
