import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player});
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: player.onPlayerStateChanged,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          final processingState = state;
          if (processingState != PlayerState.playing) {
            return IconButton(
                onPressed: player.resume,
                icon: const Icon(Icons.play_arrow_rounded));
          } else if (processingState != PlayerState.completed) {
            return IconButton(
                onPressed: player.pause, icon: const Icon(Icons.pause_rounded));
          }
          return Icon(Icons.play_arrow_rounded);
        });
  }
}
