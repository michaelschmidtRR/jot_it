import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../styles.dart';


class Note {
  final String id;
  String title;
  String content;
  Color color;
  //NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  /// Instantiates a [Note].
  Note({
    this.id,
    this.title,
    this.content,
    this.color,
    //this.state,
    DateTime createdAt,
    DateTime modifiedAt,
  }) : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  /// Transforms the Firestore query [snapshot] into a list of [Note] instances.
  static List<Note> fromQuery(QuerySnapshot snapshot) => snapshot != null ? toNotes(snapshot) : [];
}

/// State enum for a note.
// enum NoteState {
//   unspecified,
//   pinned,
//   archived,
//   deleted,
// }

/// Transforms the query result into a list of notes.
List<Note> toNotes(QuerySnapshot query) => query.docs
    .map((d) => toNote(d))
    .where((n) => n != null)
    .toList();

/// Transforms a document into a single note.
Note toNote(DocumentSnapshot doc) => doc.exists
    ? Note(
  id: doc.id,
  title: doc.data()['title'],
  content: doc.data()['content'],
  //state: NoteState.values[doc.data()['state'] ?? 0],
  color: _parseColor(doc.data()['color']),
  createdAt: DateTime.fromMillisecondsSinceEpoch(doc.data()['createdAt'] ?? 0),
  modifiedAt: DateTime.fromMillisecondsSinceEpoch(doc.data()['modifiedAt'] ?? 0),
)
    : null;

Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);



/// A single item (preview of a Note) in the Notes list.
class NoteItem extends StatelessWidget {
  const NoteItem({
    Key key,
    this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) => Hero(
    tag: 'NoteItem${note.id}',
    child: DefaultTextStyle(
      style: kNoteTextLight,
      child: Container(
        decoration: BoxDecoration(
          color: note.color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: note.color.value == 0xFFFFFFFF ? Border.all(color: kBorderColorLight) : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (note.title?.isNotEmpty == true) Text(note.title,
              style: kCardTitleLight,
              maxLines: 1,
            ),
            if (note.title?.isNotEmpty == true) const SizedBox(height: 14),
            Flexible(
              flex: 1,
              child: Text(note.content ?? ''), // wrapping using a Flexible to avoid overflow
            ),
          ],
        ),
      ),
    ),
  );
}


/// Grid view of [Note]s.
class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onTap;

  const NotesGrid({
    Key key,
    @required this.notes,
    this.onTap,
  }) : super(key: key);

  static NotesGrid create({
    Key key,
    @required List<Note> notes,
    void Function(Note) onTap,
  }) => NotesGrid(
    key: key,
    notes: notes,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1 / 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => _noteItem(context, notes[index]),
        childCount: notes.length,
      ),
    ),
  );

  Widget _noteItem(BuildContext context, Note note) => InkWell(
    onTap: () => onTap?.call(note),
    child: NoteItem(note: note),
  );
}