import 'package:flutter/material.dart';
import 'package:sudoku_plus/api/models/board.dart';
import 'package:sudoku_plus/api/models/game.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sudoku_plus/api/puzzle.dart';
import 'package:sudoku_plus/models/GameRecording.dart';
import 'package:sudoku_plus/pages/won_page.dart';

class PlayPage extends StatefulWidget {
  final double fieldSize = 40;
  final Color borderColor = Colors.grey;

  @override
  State<StatefulWidget> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  Game game;
  Position focussed;
  bool win = false;
  bool finished = false;
  Future checkGameCreated;
  DateTime _startTime;
  String _timePassedStr = '';

  GameRecording _gameRecording;

  Timer _gameTimer;

  // #region Computed Properties
  String get _gameDifficultyStr {
    final diff = GameDifficultyExtension.getByNoClues(game.noClues);
    return diff != null ? diff.value : '';
  }

  // #endregion
  _PlayPageState() {
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
    game = await generate(difficulty: GameDifficulty.DEV_EASY);
    focussed = null;
    win = false;
    finished = false;
    _startTime = DateTime.now();
    _gameRecording = GameRecording(game.board, _startTime);
    _gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      if (!finished && !win) {
        final now = DateTime.now();
        final minutes = now.difference(_startTime).inMinutes;
        final seconds = now.difference(_startTime).inSeconds % 60;
        setState(() {
          _timePassedStr =
              '${minutes < 10 ? '0' + minutes.toString() : minutes.toString()}:${seconds < 10 ? '0' + seconds.toString() : seconds.toString()}';
        });
      }
    });
    print('Board initialized');
  }

  void checkBoard() {
    if (game.board.complete()) {
      finished = true;
      if (game.win()) {
        setState(() {
          win = true;
          // redirect to
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text("Sudoku Hub"),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                focussed = null;
              });
            },
          ),

          // // Reload button
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[

          //   ],
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Win text

              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //
              //     ]),
              Expanded(
                  child: Center(
                child:
                    // Game board
                    FutureBuilder<void>(
                  future: checkGameCreated,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new CircularProgressIndicator();
                      case ConnectionState.done:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                    child: Row(children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.white),
                                      Text(
                                        _gameDifficultyStr,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      )
                                    ])),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                    child: Row(children: [
                                      Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                      ),
                                      Text(_timePassedStr,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white))
                                    ]))
                              ],
                            ),
                            _board
                          ],
                        );
                      default:
                        return Text('Starting a new game...');
                    }
                  },
                ),
              )),
              _numberPad
            ],
          )
          // Number pad
        ]),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }

  Widget get _board {
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
                              onTap: () async {
                                setState(() {
                                  if (focussed == field)
                                    focussed = null;
                                  else if (field.empty() || !field.initial)
                                    focussed = field;
                                });
                              },
                              child: Center(
                                  child: Text(
                                field.empty() ? "" : field.value.toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    color: field.initial
                                        ? Theme.of(context).primaryColor
                                        : Colors.white),
                              )),
                            ),
                            width: widget.fieldSize,
                            height: widget.fieldSize,
                            decoration: BoxDecoration(
                              color: () {
                                if (focussed == field) {
                                  return Theme.of(context).primaryColor;
                                }
                                if (field.empty()) {
                                  return Colors.white.withAlpha(50);
                                }

                                if (field.value !=
                                    game.solution.matrix[field.row][field.col]
                                        .value) {
                                  if (field.initial) {
                                    return Colors.yellow;
                                  } else {
                                    return Colors.red;
                                  }
                                } else
                                  return Colors.white.withAlpha(50);
                              }(),
                              border: Border(
                                  left: BorderSide(
                                      color: widget.borderColor,
                                      width: field.col % 3 == 0 ? 2 : 0),
                                  right: BorderSide(
                                      color: widget.borderColor,
                                      width: field.col == Board.SIZE_BASE - 1
                                          ? 2
                                          : 0),
                                  top: BorderSide(
                                      color: widget.borderColor,
                                      width: field.row % 3 == 0 ? 2 : 0),
                                  bottom: BorderSide(
                                      color: widget.borderColor,
                                      width: field.row == Board.SIZE_BASE - 1
                                          ? 2
                                          : 0)),
                            )),
                      )
                      .toList()),
            )
            .toList());
  }

  Widget get _numberPad {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, childAspectRatio: 1.6, mainAxisSpacing: 1),
          itemCount: Board.SIZE_BASE + 1,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(1),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: OutlineButton(
                child: (i == Board.SIZE_BASE
                    ? Icon(Icons.delete, color: Theme.of(context).primaryColor)
                    : Text(
                        (i + 1).toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor),
                      )),
                onPressed: () {
                  if (focussed == null) {
                    return;
                  }
                  if (!focussed.empty() && focussed.initial) {
                    return;
                  }
                  setState(() {
                    final timestamp =
                        DateTime.now().difference(_startTime).inMilliseconds;

                    if (i == Board.SIZE_BASE) {
                      final pos = Position.empty(focussed.row, focussed.col);
                      game.board.matrix[focussed.row][focussed.col] = pos;
                      _gameRecording.addMove(
                          GameRecordingMove(timestamp, MoveType.DELETE, pos));
                    } else {
                      final pos = Position(focussed.row, focussed.col, i + 1);
                      game.board.matrix[focussed.row][focussed.col] = pos;
                      _gameRecording.addMove(
                          GameRecordingMove(timestamp, MoveType.SET, pos));
                    }

                    focussed = null;
                  });
                  checkBoard();
                  if (win) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => WonPage()));
                  }
                },
              ),
            );
          },
        ),
      ))
    ]);
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    super.dispose();
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
