import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_runner/views/song_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPermission = false;

  retrievePermissions({retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
    print(await _audioQuery.queryAllPath());
  }

  @override
  void initState() {
    super.initState();
    retrievePermissions();
  }

  Widget _hasNoPermission() {
    return Container(
      width: 200,
      height: 200,
      child: const Text("App doesnt have permission to your storage."),
    );
  }
  Widget _queriedSongs(SongModel song){
    return Card(
      child: ListTile(
        title: Text(song.title),
        subtitle:
        Text(song.artist ?? "No Artist"),
        trailing: const Icon(Icons.arrow_forward_rounded),
        // This Widget will query/load image.
        // You can use/create your own widget/method using [queryArtwork].
        leading: QueryArtworkWidget(
          controller: _audioQuery,
          id: song.id,
          type: ArtworkType.AUDIO,
        ),
        onTap: (){
          _audioPlayer.play(DeviceFileSource(song.data));
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("placeholder"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _hasPermission
            ? FutureBuilder<List<SongModel>>(
                // Default values:
                future: _audioQuery.querySongs(
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
                      return SongTile(song: item.data![index], audioPlayer: _audioPlayer);
                    },
                  );
                },
              )
            : _hasNoPermission(),
      ),
    );
  }
}
