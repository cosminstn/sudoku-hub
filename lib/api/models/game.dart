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
        if (board.matrix[row][col].value != solution.matrix[row][col].value) {
          return false;
        }
      }
    }
    return true;
  }
}

enum GameDifficulty { EASY, MEDIUM, HARD, EVIL }

extension GameDifficultyExtension on GameDifficulty {
  int get minClues {
    switch (this) {
      case GameDifficulty.EASY:
        return 36;
      case GameDifficulty.MEDIUM:
        return 32;
      case GameDifficulty.HARD:
        return 28;
      case GameDifficulty.EVIL:
        return 17;
      default:
        return null;
    }
  }

  int get maxClues {
    switch (this) {
      case GameDifficulty.EASY:
        return 46;
      case GameDifficulty.MEDIUM:
        return 35;
      case GameDifficulty.HARD:
        return 31;
      case GameDifficulty.EVIL:
        return 27;
      default:
        return null;
    }
  }

  static GameDifficulty getByNoClues(int noClues) {
    for (var diff in GameDifficulty.values) {
      if (noClues >= diff.minClues && noClues <= diff.maxClues) {
        return diff;
      }
    }
    return null;
  }
}
