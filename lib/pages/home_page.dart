import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_plus/pages/play_page.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Container(
                  width: 200,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                            // child: Icon(Icons.hot_tub, size: 50),
                            child: Image.asset('assets/homepage_logo.png')),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _newGameButton(context),
                            _statsButton(context),
                            _settingsButton(context),
                            _signOutButton(context)
                          ],
                        )
                      ]))),
        ));
  }

  Widget _buildStandardButton(
      BuildContext context, IconData icon, String text, Function onPressed) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: RaisedButton(
            onPressed: () {
              onPressed();
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            color: Theme.of(context).primaryColor,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(icon),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                              child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ))),
                    )
                  ],
                ))));
  }

  Widget _newGameButton(BuildContext context) {
    return _buildStandardButton(context, Icons.add, 'New Game', () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PlayPage()));
    });
  }

  Widget _statsButton(BuildContext context) {
    return _buildStandardButton(context, Icons.history, 'Statistics', () {});
  }

  Widget _settingsButton(BuildContext context) {
    return _buildStandardButton(context, Icons.settings, 'Settings', () {
      print('Clicked settings');
    });
  }

  Widget _signOutButton(BuildContext context) {
    return _buildStandardButton(context, Icons.exit_to_app, 'Sign Out', () {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    });
  }
}
