import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_runner/views/home.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  MainApp({super.key});
  final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent,
        brightness: Brightness.light
    ),
    useMaterial3: true,
  );
  final darkTheme =ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent,
        brightness: Brightness.dark
    ),
    useMaterial3: true,
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music runner',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }
}
