import 'package:flutter/material.dart';
import 'package:sudoku_plus/pages/play_page.dart';

class HomePage extends StatelessWidget {
  static final COLOR_ORANGE = Color(0xffffa500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            _settingsButton(context)
                          ],
                        )
                      ]))),
        ));
  }

  Widget _newGameButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PlayPage()));
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            color: COLOR_ORANGE,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.add),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'New Game',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ))));
  }

  Widget _settingsButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: RaisedButton(
            onPressed: () {
              print('Clicked settings');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            color: COLOR_ORANGE,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.settings),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )
                  ],
                ))));
  }
}
