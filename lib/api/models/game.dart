import 'board.dart';

class Game {
  final Board board, solution;

  Game(this.board, this.solution);

  bool win() {
    if (!board.complete()) {
      return false;
    }

    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board.matrix[row][col] != solution.matrix[row][col]) {
          return false;
        }
      }
    }
    return true;
  }
}
