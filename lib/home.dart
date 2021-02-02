import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Models/note.dart';
import 'authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Home screen, displays [Note] in a Grid or List.
///

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User>();
//
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("JotIt"),
//       ),
//       body: new Center(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('notes-${firebaseUser.uid}').snapshots(),
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             return !snapshot.hasData
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                   DocumentSnapshot data = snapshot.data.docs[index];
//                     return Text(data.data()['title']);
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: new FloatingActionButton(
//         //onPressed: ,
//         tooltip: 'New note',
//         child: new Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Listens to the value and exposes it to all of StreamProvider descendants.
  @override
  Widget build(BuildContext context) => StreamProvider.value(
        value: _createNoteStream(context),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _appBar(context), // a floating appbar
              const SliverToBoxAdapter(
                child: SizedBox(height: 24), // top spacing
              ),
              _buildNotesView(context),
              const SliverToBoxAdapter(
                child: SizedBox(
                    height:
                        80.0), // bottom spacing make sure the content can scroll above the bottom bar
              ),
            ],
          ),
          floatingActionButton: _fab(context),
          //bottomNavigationBar: _bottomActions(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          extendBody: true,
        ),
      );

  /// A floating appBar like the one of Google Keep
  Widget _appBar(BuildContext context) => SliverAppBar(
        floating: true,
        snap: true,
        title: Text("JotIt"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Widget _fab(BuildContext context) => FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      );

  Widget _buildNotesView(BuildContext context) => Consumer<List<Note>>(
        builder: (context, notes, _) {
          if (notes?.isNotEmpty != true) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Text(
                'Notes you add appear here',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            );
          }

          final widget = NotesGrid.create;
          return widget(notes: notes, onTap: (_) {});
        },
      );

  Stream<List<Note>> _createNoteStream(BuildContext context) {
    //final firebaseUser = context.watch<User>();

    final uid = Provider.of<User>(context)?.uid;
    return FirebaseFirestore.instance.collection('notes-$uid')
        //.where('state', isEqualTo: 0)
        .snapshots()
        //.handleError((e) => debugPrint('query failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }
}
//
//   Widget _topActions(BuildContext context) => Container(
//     width: double.infinity,
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5),
//         child: Row(
//           children: <Widget>[
//             const SizedBox(width: 20),
//             const Icon(Icons.menu),
//             const Expanded(
//               child: Text('Search your notes', softWrap: false),
//             ),
//             InkWell(
//               child: Icon(_gridView ? Icons.view_list : Icons.view_module),
//               onTap: () => setState(() {
//                 _gridView = !_gridView; // switch between list and grid style
//               }),
//             ),
//             const SizedBox(width: 18),
//             //_buildAvatar(context),
//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     ),
//   );
//
//   Widget _bottomActions() => BottomAppBar(
//     shape: const CircularNotchedRectangle(),
//     child: Container(
//       height: 56.0,
//       padding: const EdgeInsets.symmetric(horizontal: 17),
//       child: Row(
//       //...
//       ),
//     ),
//   );
//
//   Widget _fab(BuildContext context) => FloatingActionButton(
//     child: const Icon(Icons.add),
//     onPressed: () {},
//   );
//
//
//   /// A grid/list view to display notes
//   Widget _buildNotesView(BuildContext context) => Consumer<List<Note>>(
//     builder: (context, notes, _) {
//       if (notes?.isNotEmpty != true) {
//         return _buildBlankView();
//       }
//
//       final widget = _gridView ? NotesGrid.create : null;
//       return widget(notes: notes, onTap: (_) {});
//     },
//   );
//
//   //Creates a sliver that fills the remaining space in the viewport.
//   //Sliver is a scrollable area used for custom scrolling
//   Widget _buildBlankView() => const SliverFillRemaining(
//     hasScrollBody: false,
//     child: Text('Notes you add appear here',
//       style: TextStyle(
//         color: Colors.black54,
//         fontSize: 14,
//       ),
//     ),
//   );
//
//   /// Create the notes query
//   Stream<List<Note>> _createNoteStream(BuildContext context) {
//     //final firebaseUser = context.watch<User>();
//
//     final uid = Provider.of<User>(context)?.uid;
//     return Firestore.instance.collection('notes-$uid')
//         //.where('state', isEqualTo: 0)
//         .snapshots()
//         .handleError((e) => debugPrint('query failed: $e'))
//         .map((snapshot) => Note.fromQuery(snapshot));
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("JotIt")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("WELCOME HOME",style:TextStyle(fontSize: 30)),
//
//
//             RaisedButton(
//               onPressed: () {
//                 context.read<AuthenticationProvider>().signOut();
//               },
//               child: Text("Sign out"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
