import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SongListing extends StatefulWidget {
  const SongListing({super.key, required this.audioQuery});
  final OnAudioQuery audioQuery;
  @override
  State<SongListing> createState() => _SongListingState();
}

class _SongListingState extends State<SongListing> {
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
        // List<SongModel> songs = item.data!;
        return ListView.builder(
          itemCount: item.data!.length,
          itemBuilder: (context, index) {
            // print(item.data![index].data );
            return _listTile(item.data![index]);
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
      trailing: Icon( Icons.menu),

      onTap: () {
      },
    ),
  );

}
