import 'package:flutter/material.dart';
class SongMetadata extends StatelessWidget {
  const SongMetadata({super.key, required this.title, required this.artist});
  final String title;
  final String? artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          color: Colors.red,
        ),
        const  SizedBox(
          width: 10,
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        Text(
          artist != null ? artist! : "Unknown",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
