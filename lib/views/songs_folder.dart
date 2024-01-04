// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:path/path.dart' as path;

class SongsInFolderListing extends StatefulWidget {
  const SongsInFolderListing({super.key, required this.directory, required this.basename, required this.audioQuery});
  final OnAudioQuery audioQuery;
  final String basename;
  final String directory;
  @override
  State<SongsInFolderListing> createState() => _SongsInFolderListingState();
}

class _SongsInFolderListingState extends State<SongsInFolderListing> {

  Future<List<SongModel>> fetchSongs() async{
    return await widget.audioQuery.queryFromFolder(widget.directory);
    // Directory dir = Directory(widget.directory);
    // List<FileSystemEntity> content = await dir.list(followLinks: false).toList();
    // return content.where((file) => file.path.endsWith("mp4") || file.path.endsWith("mp3") || file.path.endsWith('.wav')
    //     || file.path.endsWith('.au') || file.path.endsWith('.smi')
    // ).map((e) => e.path).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.basename),),
      body: FutureBuilder<List<SongModel>>(
        future: fetchSongs(),
        builder: (context, item){
          if (item.hasError) {
            return Text(item.error.toString());
          }
          // Waiting content.
          if (item.data == null) {
            return const CircularProgressIndicator();
          }
          // 'Library' is empty.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index){
                  return ListTile(
                    leading: Icon(Icons.music_note),
                    title: Text(item.data![index].title),
                  );
              });
        },
      ),
    );
  }
}
