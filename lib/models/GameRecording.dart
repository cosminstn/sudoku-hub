import 'package:equatable/equatable.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:sudoku_plus/api/models/board.dart';

class GameRecording {
  final Board puzzle;
  final DateTime startTime;
  final OrderedSet<GameRecordingMove> _moves;
  DateTime completionTime;

  GameRecording(this.puzzle, this.startTime)
      : _moves =
            OrderedSet<GameRecordingMove>(Comparing.on((m) => m.timestamp));

  GameRecording.load(
      this.puzzle, this.startTime, this.completionTime, this._moves);

  void addMove(GameRecordingMove move) {
    _moves.add(move);
  }

  OrderedSet<GameRecordingMove> get moves => _moves;
}

class GameRecordingMove extends Equatable {
  // Equatable helps us simplify overriding equals and hashCode, by just overriding the Equatable class props.
  // Note: All members used in Equatable's props must be final.
  final int timestamp; // millis since the start of the game
  final MoveType moveType;
  final Position position;

  GameRecordingMove(this.timestamp, this.moveType, this.position);

  GameRecordingMove.setPosition(this.timestamp, int row, int col, int value)
      : moveType = MoveType.SET,
        position = Position(row, col, value);

  GameRecordingMove.emptyPosition(this.timestamp, int row, int col)
      : moveType = MoveType.DELETE,
        position = Position.empty(row, col);

  @override
  List<Object> get props => [timestamp, moveType];
}

enum MoveType { SET, DELETE }
