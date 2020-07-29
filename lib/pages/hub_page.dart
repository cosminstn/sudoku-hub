import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HubPage extends StatelessWidget {
  final Firestore firestore;

  HubPage() : firestore = Firestore.instance {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Sudoku Hub - Share and watch"),
        centerTitle: true,
      ),
    );
  }
}

class RecordingsList extends StatelessWidget {
  RecordingsList({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection("recordings")
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            final dynamic message = document['message'];
            return ListTile(
              trailing: IconButton(
                onPressed: () => document.reference.delete(),
                icon: Icon(Icons.delete),
              ),
              title: Text(
                message != null ? message.toString() : '<No message retrieved>',
              ),
              subtitle: Text('Message ${index + 1} of $messageCount'),
            );
          },
        );
      },
    );
  }
}
