import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatefulWidget {
  final SongModel song;
  final AudioPlayer audioPlayer;
  const SongTile({super.key, required this.song, required this.audioPlayer});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {

  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.song.title),
        subtitle:
        Text(widget.song.artist ?? "No Artist"),
        trailing: Icon( _isPlaying? Icons.arrow_forward_rounded : Icons.stop),

        onTap: () {

          if(_isPlaying){
            // print(_isPlaying);
             widget.audioPlayer.stop();
          } else {
            widget.audioPlayer.play(DeviceFileSource(widget.song.data));
          }
        },
      ),
    );
  }
}
