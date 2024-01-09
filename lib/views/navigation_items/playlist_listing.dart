import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_runner/views/dialogs/create_playlist_dialog.dart';
import 'package:music_runner/views/music_player/music_player.dart';
import 'package:music_runner/views/playlist_items.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListListing extends StatefulWidget {
  const PlayListListing({super.key, required this.audioQuery});
  final OnAudioQuery audioQuery;
  @override
  State<PlayListListing> createState() => _PlayListListingState();
}

class _PlayListListingState extends State<PlayListListing> {
  final _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<List<PlaylistModel>>(
        // Default values:
        future: widget.audioQuery.queryPlaylists(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.hasError) {
            return Text(item.error.toString());
          }

          if (item.data == null) {
            return const CircularProgressIndicator();
          }

          if (item.data!.isEmpty) return const Text("Nothing found!");

          List<PlaylistModel> songs = item.data!;
          return ListView.separated(
            itemCount: songs.length,
            // shrinkWrap: ,
            itemBuilder: (context, index) {
              return _listTile(songs[index]);
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 4,
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return CreatePlaylistDialog(audioQuery: widget.audioQuery);
              }).whenComplete(() {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listTile(PlaylistModel playlist) =>Card(
            child:   Container(
              height: 90,
              padding: EdgeInsets.symmetric(vertical: 10),
              child:  ListTile(
          title: Text(playlist.playlist, style: Theme.of(context).textTheme.headlineMedium,),
          subtitle: Text("Number of songs ${playlist.numOfSongs}", style: Theme.of(context).textTheme.labelLarge,),
          trailing: IconButton(
            icon: const Icon(Icons.delete, size: 36,),
            onPressed: () {
              _showRemoveDialog(playlist);
            },
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlayListItems(
                          model: playlist,
                          audioQuery: widget.audioQuery,
                        )));
          },
        ),
      ));

  void _showRemoveDialog(PlaylistModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Are you sure you want to delete '${model.playlist}'", style: const TextStyle(fontSize: 18),),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              MaterialButton(
                  onPressed: () async {
                    final created =
                        await widget.audioQuery.removePlaylist(model.id);
                    if (created) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  color: Theme.of(context).canvasColor,
                  child: const Text("Yes")),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                color: Theme.of(context).canvasColor,
                child: const Text("No"),
              )
            ],
          );
        });
  }
}
