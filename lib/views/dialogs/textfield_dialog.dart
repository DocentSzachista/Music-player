import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlertDialogWithTextField extends StatefulWidget {
  const AlertDialogWithTextField({super.key, required this.audioQuery, this.playlistModel});
  final PlaylistModel? playlistModel;
  final OnAudioQuery audioQuery;
  @override
  State<AlertDialogWithTextField> createState() => _AlertDialogWithTextFieldState();
}

class _AlertDialogWithTextFieldState extends State<AlertDialogWithTextField> {
  final TextEditingController _textFieldController = TextEditingController();
  bool _isEmpty = false;
  final RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  @override
  void initState() {
    if(widget.playlistModel != null){
      _textFieldController.text = widget.playlistModel!.playlist;
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.playlistModel == null ? "Create new playlist" : "Edit playlist name"),
      content: TextField(
        onChanged: (value) {
          setState(() {
            _isEmpty = value.isEmpty;
          });
        },
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Your new playlist name", errorText: _isEmpty ? "Playlist name cant be empty" : null),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        MaterialButton(
            onPressed: () async {
              if(_textFieldController.text.isNotEmpty) {
                bool created = false;
                if (widget.playlistModel != null){
                  created = await _editPlaylist(_textFieldController.text, widget.playlistModel!.id);
                }
                else{
                  created = await _createNewPlaylist(_textFieldController.text);
                }
                print(created);
                if (created) {
                  setState(() {
                    _textFieldController.text = "";
                    Navigator.pop(context);
                  });
                }
              }
              else{
                setState(() {
                  _isEmpty = true;
                });
              }
            },
            color: Theme.of(context).canvasColor,
            shape: _buttonShape,
            child: const Text("Create")),
        MaterialButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          shape: _buttonShape,
          color: Theme.of(context).canvasColor,
          child: const Text("Cancel"),
        )
      ],
      buttonPadding: const EdgeInsets.symmetric(horizontal: 60),
    );
  }
  Future<bool> _createNewPlaylist(String title) async{
    return await widget.audioQuery
        .createPlaylist(title);
  }
  Future<bool> _editPlaylist(String title, int playlistId) async{
    return await widget.audioQuery.renamePlaylist(playlistId, title);
  }

}

