/// The board is a 9 by 9 matrix containing values from 1 to 9.
/// If a position is considered empty then it will contain the value 0.
class Board {
  static const int SIZE_BASE = 9;

  // TODO: Readonly access to this data structure
  List<List<Position>> matrix;

  ///Initializes a 9x9 board with 0 all over.
  Board.empty() {
    matrix = <List<Position>>[];
    for (var i = 0; i < 9; i++) {
      var row = <Position>[];
      for (var j = 0; j < 9; j++) {
        row.add(Position.empty(i, j, initial: true));
      }
      matrix.add(row);
    }
  }

  bool isNumberOnRow(int number, int row) {
    return matrix[row].map((pos) => pos.value).contains(number);
  }

  bool isNumberOnColumn(int number, int col) {
    for (var row in matrix) {
      if (row[col].value == number) {
        return true;
      }
    }
    return false;
  }

  Region getRegion(int row, int col) {
    return Region(this, row - (row % 3), col - (col % 3));
  }

  int getNoClues() {
    var clues = 0;
    for (var row in matrix) {
      for (var el in row) {
        if (!el.empty()) {
          clues++;
        }
      }
    }
    return clues;
  }

  void printBoard() {
    for (var row in matrix) {
      var line = '';
      for (var number in row) {
        line += '${number.value} ';
      }
      print(line);
    }
  }

  bool complete() {
    for (var row in matrix) {
      for (var el in row) {
        if (el.empty()) {
          return false;
        }
      }
    }
    return true;
  }

  Board clone() {
    var clone = Board.empty();

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        clone.matrix[i][j] = matrix[i][j].clone();
      }
    }

    return clone;
  }
}

/**
 * The region is a 3 by 3 section on the Board. 
 * The board contains 9 regions. 
 * Any number should appear only once in a region.
 */
class Region {
  List<List<Position>> _matrix;

  Region(Board board, int rowStart, int colStart) {
    assert(rowStart == 0 || rowStart == 3 || rowStart == 6);
    assert(colStart == 0 || colStart == 3 || colStart == 6);
    _matrix = <List<Position>>[];
    for (var row = rowStart; row < rowStart + 3; row++) {
      _matrix.add([
        board.matrix[row][colStart],
        board.matrix[row][colStart + 1],
        board.matrix[row][colStart + 2]
      ]);
    }
  }

  bool contains(int number) {
    assert(number >= 1 && number <= 9);
    for (var row in _matrix) {
      for (var pos in row) {
        if (!pos.empty() && pos.value == number) {
          return true;
        }
      }
    }
    return false;
  }
}

class Position {
  final int row, col;
  final int value;
  final bool initial;

  Position(this.row, this.col, this.value, {this.initial = false})
      : assert(row >= 0 && row < 9),
        assert(col >= 0 && col < 9),
        assert(value >= 0 && value <= 9);

  Position.empty(int row, int col, {bool initial = false})
      : this(row, col, 0, initial: initial);

  bool empty() {
    return value == 0;
  }

  Position clone() {
    return Position(row, col, value, initial: initial);
  }
}
