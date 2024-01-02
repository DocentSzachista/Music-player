import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_runner/views/navigation_items/directory_listing.dart';
import 'package:music_runner/views/navigation_items/song_listing.dart';
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
  int _selectedIndex = 0;





  static const List<BottomNavigationBarItem> _bottomBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.featured_play_list),
      label: 'Playlists',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder),
      label: 'Memory',
    ),
  ];
  static const List<Text> headers = [
    Text("Songs"),
    Text("Playlists"),
    Text("Memory")
  ];
  List<Widget> options() => [
    SongListing(audioQuery: _audioQuery),
    Placeholder(),
    DirectoryListing(audioQuery: _audioQuery, audioPlayer: _audioPlayer),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  retrievePermissions({retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  void initState() {
    super.initState();
    retrievePermissions();
  }

  Widget _hasNoPermission() {
    return SizedBox(
      width: 200,
      height: 200,
      child: const Text("App doesnt have permission to your storage."),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> views = options();
    return Scaffold(
      appBar: AppBar(
        title: headers.elementAt(_selectedIndex),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _hasPermission
            ? views.elementAt(_selectedIndex)
            : _hasNoPermission(),
      ),
    );
  }
}
