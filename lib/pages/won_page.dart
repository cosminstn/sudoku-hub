import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
            child: Text("Congratulations, you won!",
                style: TextStyle(fontSize: 20, color: Colors.green)),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: MaterialButton(
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () async {
                      final documentReference = await uploadRecording();
                      print(
                          'Recording uploaded with id: ${documentReference.documentID}');
                    },
                  )),
                  Expanded(
                      child: MaterialButton(
                    child: Text(
                      'Dont upload',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {},
                  ))
                ],
              ))
        ])));
  }

  Future<DocumentReference> uploadRecording() async {
    final ref = Firestore.instance.collection('recordings').document();

    await ref
        .setData({'title': 'Firts Recording', 'created_at': DateTime.now()});

    return ref;
  }
}
