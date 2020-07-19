import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api/models/board.dart';
import 'api/models/game.dart';
import 'api/puzzle.dart';

class GameMenu extends StatefulWidget {
  final double fieldSize = 40;
  final Color borderColor = Colors.grey;

  @override
  State<StatefulWidget> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  Game game;
  Position focussed;
  bool win = false;
  bool finished = false;
  Future checkGameCreated;

  _GameMenuState() {
    // board.load().then((loaded) {
    //   setState(() {
    //     if (!loaded) createNewBoard();
    //   });
    //   WidgetsBinding.instance.addObserver(LifecycleHandler(
    //       suspendingCallBack: () async {
    //         if (!win)
    //           board.save();
    //         else
    //           board.removeFile();
    //       },
    //       resumeCallBack: () {}));
    // });
    // createNewBoard();
    checkGameCreated = checkGameInitializedAsync();
  }

  Future<void> checkGameInitializedAsync() async {
    if (game != null) {
      return;
    }
    game = await generate(attempts: 5);
    focussed = null;
    win = false;
    finished = false;
    print('Board initialized');
  }

  void checkBoard() {
    if (game.board.complete()) {
      finished = true;
      if (game.win()) {
        setState(() {
          win = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                focussed = null;
              });
            },
          ),
          // Title
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(!win ? "Sudoku Plus" : "Congratulations, you won!",
                  style: TextStyle(
                      fontSize: 20, color: win ? Colors.green : null)),
            )
          ]),
          // Reload button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                  child: IconButton(
                    icon: Icon(Icons.autorenew),
                    onPressed: () =>
                        setState(() async => await checkGameInitializedAsync()),
                  ))
            ],
          ),
          Center(
            child:
                // Game board
                FutureBuilder<void>(
              future: checkGameCreated,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new CircularProgressIndicator();
                  case ConnectionState.done:
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: game.board.matrix
                            .map(
                              (list) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: list
                                      .map(
                                        (field) => Container(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (focussed == field)
                                                    focussed = null;
                                                  else if (field.empty() ||
                                                      !field.initial)
                                                    focussed = field;
                                                });
                                              },
                                              child: Center(
                                                  child: Text(
                                                field.empty()
                                                    ? ""
                                                    : field.value.toString(),
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: field.initial
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : null),
                                              )),
                                            ),
                                            width: widget.fieldSize,
                                            height: widget.fieldSize,
                                            decoration: BoxDecoration(
                                              color: () {
                                                if (focussed == field) {
                                                  return Theme.of(context)
                                                      .primaryColor;
                                                }
                                                if (field.empty()) {
                                                  return Colors.white
                                                      .withAlpha(50);
                                                }

                                                if (field.value !=
                                                    game
                                                        .solution
                                                        .matrix[field.row]
                                                            [field.col]
                                                        .value) {
                                                  if (field.initial) {
                                                    return Colors.yellow;
                                                  } else {
                                                    return Colors.red;
                                                  }
                                                } else
                                                  return Colors.white
                                                      .withAlpha(50);
                                              }(),
                                              border: Border(
                                                  left: BorderSide(
                                                      color: widget.borderColor,
                                                      width: field.col % 3 == 0
                                                          ? 2
                                                          : 0),
                                                  right: BorderSide(
                                                      color: widget.borderColor,
                                                      width: field.col ==
                                                              Board.SIZE_BASE -
                                                                  1
                                                          ? 2
                                                          : 0),
                                                  top: BorderSide(
                                                      color: widget.borderColor,
                                                      width: field.row % 3 == 0
                                                          ? 2
                                                          : 0),
                                                  bottom: BorderSide(
                                                      color: widget.borderColor,
                                                      width: field.row ==
                                                              Board.SIZE_BASE -
                                                                  1
                                                          ? 2
                                                          : 0)),
                                            )),
                                      )
                                      .toList()),
                            )
                            .toList());
                  default:
                    return Text('hello');
                }
              },
            ),
          ),
          // Number pad
          (focussed != null && !game.win()
              ? Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                  Widget>[
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1.6,
                          mainAxisSpacing: 1),
                      itemCount: Board.SIZE_BASE + 1,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(1),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: OutlineButton(
                            child: (i == Board.SIZE_BASE
                                ? Icon(Icons.delete)
                                : Text(
                                    (i + 1).toString(),
                                    style: TextStyle(fontSize: 30),
                                  )),
                            onPressed: () {
                              if (focussed == null) {
                                return;
                              }
                              if (!focussed.empty() && focussed.initial) {
                                return;
                              }
                              setState(() {
                                if (i == Board.SIZE_BASE)
                                  game.board.matrix[focussed.row]
                                          [focussed.col] =
                                      Position.empty(
                                          focussed.row, focussed.col);
                                else
                                  game.board.matrix[focussed.row]
                                          [focussed.col] =
                                      Position(
                                          focussed.row, focussed.col, i + 1);
                                focussed = null;
                              });
                              checkBoard();
                            },
                          ),
                        );
                      },
                    ),
                  ))
                ])
              : Container()),
        ]),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}

class LifecycleHandler extends WidgetsBindingObserver {
  LifecycleHandler({this.resumeCallBack, this.suspendingCallBack});

  final void Function() resumeCallBack;
  final void Function() suspendingCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }
}
