import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_runner/views/common_song_list_tile.dart';
import 'package:music_runner/views/dialogs/create_playlist_dialog.dart';
import 'package:music_runner/views/music_player/music_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListing extends StatefulWidget {
  const SongListing({super.key, required this.audioQuery});
  final OnAudioQuery audioQuery;
  @override
  State<SongListing> createState() => _SongListingState();
}

class _SongListingState extends State<SongListing> {
  List<AudioSource> _audioSources = [];
  int _selectedValue = -1;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      // Default values:
      future: widget.audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, item) {
        // Display error, if any.
        if (item.hasError) {
          return Text(item.error.toString());
        }

        // Waiting content.
        if (item.data == null) {
          return const CircularProgressIndicator();
        }

        // 'Library' is empty.
        if (item.data!.isEmpty) return const Text("Nothing found!");

        // You can use [item.data!] direct or you can create a:
        List<SongModel> songs = item.data!;
        _audioSources = songs
            .map((song) => AudioSource.file(song.data, tag: song))
            .toList();
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return CommonSongListTile(
              song: songs[index],
              audioSources: _audioSources,
              index: index,
              trailing: IconButton(
                icon: const Icon(Icons.add_box),
                onPressed: () {
                  _showPlaylistsDialog(songs[index].id);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showPlaylistsDialog(int songId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add to playlist"),
            content: FutureBuilder<List<PlaylistModel>>(
              future: widget.audioQuery.queryPlaylists(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.data == null) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data!.isEmpty) {
                  return MaterialButton(onPressed: (){
                    Navigator.of(context).pop();
                    showDialog(context: context, builder: (context){
                      return CreatePlaylistDialog(audioQuery: widget.audioQuery,);
                    }).whenComplete((){ setState(() {
                      _showPlaylistsDialog(songId);
                    });});
                  });
                }
                _selectedValue = snapshot.data!.first.id;
                return DropdownMenu<int>(
                    width: 250,
                    initialSelection: snapshot.data!.first.id,
                    onSelected: (value) {
                      _selectedValue = value!;
                    },
                    dropdownMenuEntries: snapshot.data!
                        .map((playlist) => DropdownMenuEntry(
                            value: playlist.id, label: playlist.playlist))
                        .toList());
              },
            ),
            actions: [
              MaterialButton(
                  onPressed: () async {
                    final created = await widget.audioQuery
                        .addToPlaylist(_selectedValue, songId);
                    if (created) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  color: Theme.of(context).canvasColor,
                  child: const Text("Add")),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                color: Theme.of(context).canvasColor,
                child: const Text("Cancel"),
              )
            ],
          );
        });
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
