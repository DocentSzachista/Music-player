import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_runner/views/music_player/player_controls.dart';
import 'package:music_runner/views/music_player/position_data.dart';
import 'package:music_runner/views/music_player/song_metadata.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key, required this.song, required this.playlist});

  final SongModel song;
  final List<AudioSource> playlist;
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  late ConcatenatingAudioSource playlist;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (pos, bufferedPos, dur) =>
              PositionData(pos, bufferedPos, dur ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    // audioPlayer.setFilePath((widget.song.data));
    playlist = ConcatenatingAudioSource(children: widget.playlist);
    _init();
  }
  Future<void> _init() async{
    await audioPlayer.setLoopMode(LoopMode.all);
    await audioPlayer.setAudioSource(playlist);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar( backgroundColor: Colors.transparent, ),
      body: Container(
        height: double.maxFinite,
      width: double.maxFinite,
      decoration: const BoxDecoration( gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.tealAccent, Colors.indigo])),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(stream: audioPlayer.sequenceStateStream, builder: (context, snapshot){
                  final state = snapshot.data;
                  if(state?.sequence.isEmpty ?? true){
                    return const SizedBox();
                  }
                  final MediaItem metadata = state!.currentSource!.tag;
                  return SongMetadata(title: metadata.title, artist: metadata.artist);
                }),
                StreamBuilder(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final posData = snapshot.data;
                      return ProgressBar(
                        buffered: posData?.bufferedPos ?? Duration.zero,
                        progress: posData?.position ?? Duration.zero,
                        total: posData?.duration ?? Duration.zero,
                        onSeek: audioPlayer.seek,
                      );
                    }),
                Controls(player: audioPlayer)
              ],
            )),
      ),
    ),);
  }
}
