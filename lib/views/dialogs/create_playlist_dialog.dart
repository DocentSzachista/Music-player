import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key, required this.audioQuery});
  final OnAudioQuery audioQuery;
  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create new playlist"),
      content: TextField(
        onChanged: (value) {},
        controller: _textFieldController,
        decoration:
        const InputDecoration(hintText: "Your new playlist name"),
      ),
      actions: [
        MaterialButton(
            onPressed: () async {
              final created = await widget.audioQuery
                  .createPlaylist(_textFieldController.text);
              if (created) {
                setState(() {
                  _textFieldController.text = "";
                  Navigator.pop(context);
                });
              }
            },
            color: Theme.of(context).canvasColor,
            child: const Text("Create")),
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
      buttonPadding: const EdgeInsets.symmetric(horizontal: 60),
    );
  }
}
