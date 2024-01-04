import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
        _audioSources = songs.map((song) => AudioSource.file(song.data, tag: song)).toList();
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            // print(item.data![index].data );
            return _listTile(songs[index]);
          },
        );
      },
    );
  }

  Widget _listTile(SongModel song) => Card(
    child: ListTile(
      title: Text(song.title),
      subtitle:
      Text(song.artist ?? "No Artist"),
      trailing: const Icon( Icons.menu),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MusicPlayer(song: song, playlist: _audioSources,)));
      },
    ),
  );

}
