import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_runner/views/common_song_list_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListItems extends StatefulWidget {
  const PlayListItems({super.key, required this.model, required this.audioQuery});
  final PlaylistModel model;
  final OnAudioQuery audioQuery;
  @override
  State<PlayListItems> createState() => _PlayListItemsState();
}

class _PlayListItemsState extends State<PlayListItems> {

  List<AudioSource> audioSources = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.model.playlist),),
        body: Center(child:FutureBuilder<List<SongModel>>(
          future: _fetchFromPlaylist(),
          builder: (context, snapshot){
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            }

            if (snapshot.data!.isEmpty) return const Text("Nothing found!");

            List<SongModel> songs = snapshot.data!;
            audioSources = songs
                .map((song) => AudioSource.file(song.data, tag: song))
                .toList();
            return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index){
                  return CommonSongListTile(song: songs[index], audioSources: audioSources, index: index);
                });

          },
        ),
        ));
  }
  Future<List<SongModel>> _fetchFromPlaylist() async{
    List<SongModel> songsInPlaylist = await widget.audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST,
        widget.model.playlist
    );
    return songsInPlaylist;
  }
}

