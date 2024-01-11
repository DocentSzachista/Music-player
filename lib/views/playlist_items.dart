import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
                .map((song) => AudioSource.file(song.data, tag: MediaItem(id: "${song.id}", title: song.title, album: song.album, genre: song.genre)))
                .toList();
            return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index){
                  return CommonSongListTile(song: songs[index], audioSources: audioSources, index: index, trailing:
                    IconButton(
                      icon: const Icon(Icons.delete, size: 24,),
                      onPressed: () async {
                        final removed = await widget.audioQuery.removeFromPlaylist(widget.model.id, songs[index].id);
                        // _showRemoveDialog(playlist);
                        print(removed);
                        if(removed) {
                          setState(() {});
                        }
                      },
                    ),

                    );
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

