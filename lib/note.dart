import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Models/note.dart';

/*class NoteScreen extends StatefulWidget {
  /// Create a [NoteEditor],
  /// provides an existed [note] in edit mode, or `null` to create a new one.
  const NoteScreen({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  State<StatefulWidget> createState() => _NoteScreenState(note);
}*/

class NoteScreen extends StatefulWidget {
  @override
  const NoteScreen({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  State<StatefulWidget> createState() => _NoteScreenState(note);
}

class _NoteScreenState extends State<NoteScreen> {
  _NoteScreenState(Note note);

  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      return Scaffold();
    }

    return Scaffold();
  }
}
