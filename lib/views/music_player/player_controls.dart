import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player});
  final AudioPlayer player;
  static const double buttonSize = 60;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: player.seekToPrevious, icon: const Icon(Icons.skip_previous_sharp, size: buttonSize,)),
        StreamBuilder(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final playing = state?.playing;
              final processingState = state?.processingState;
              if (!(playing ?? false)) {
                return IconButton(
                    onPressed: player.play,
                    icon: const Icon(Icons.play_arrow_rounded, size: buttonSize));
              } else if (processingState! != ProcessingState.completed) {
                return IconButton(
                    onPressed: player.pause,
                    icon: const Icon(Icons.pause_rounded, size: buttonSize));
              }
              return const Icon(Icons.play_arrow_rounded, size: buttonSize);
            }),
        IconButton(onPressed: player.seekToNext, icon: const Icon(Icons.skip_next_sharp, size: buttonSize,)),
      ],
    );
  }
}
