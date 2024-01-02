import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DirectoryListing extends StatefulWidget {
  const DirectoryListing(
      {super.key, required this.audioQuery, required this.audioPlayer});
  final OnAudioQuery audioQuery;
  final AudioPlayer audioPlayer;

  @override
  State<DirectoryListing> createState() => _DirectoryListingState();
}

class _DirectoryListingState extends State<DirectoryListing> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.audioQuery.queryAllPath(),
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

        List<String> dirs = item.data!.toList();
        dirs = dirs
            .where((item) =>
                item.contains("Download") ||
                (item.contains("Music") && !item.contains("Android")))
            .toList();

        return ListView.builder(
          itemCount: dirs.length,
          itemBuilder: (context, index) {
            String path = dirs[index];
            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(path.substring(path.indexOf("0") + 2)),
              subtitle:
                  Text(path.length > 40 ? "${path.substring(0, 40)}..." : path),
            );
          },
        );
      },
    );
  }
}
