import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'music_player/music_player.dart';

class CommonSongListTile extends StatelessWidget {
  const CommonSongListTile(
      {super.key,
      required this.song,
      required this.audioSources,
      required this.index, this.trailing});
  final int index;
  final SongModel song;
  final List<AudioSource> audioSources;
  final IconButton? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(song.title),
        subtitle: Text(song.artist ?? "No Artist"),
        trailing: trailing,

        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                        song: song,
                        playlist: _moveObjectsByIndexToEnd(audioSources, index),
                      )));
        },
      ),
    );
  }

  List<AudioSource> _moveObjectsByIndexToEnd(
      List<AudioSource> objectsList, int index) {
    if (index >= 0 && index < objectsList.length) {
      List<AudioSource> temp = List.of(objectsList);
      List<AudioSource> tempList = temp.sublist(0, index);
      temp.removeRange(0, index);
      temp.addAll(tempList);
      return temp;
    }
    return objectsList;
  }
}
