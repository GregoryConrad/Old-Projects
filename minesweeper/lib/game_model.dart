import 'dart:math';

class Board {
  List<List<Tile>> board;
  bool initialized = false;
  int _numOfMines;
  Function onWin, onLose;

  Board(int rows, int columns, this._numOfMines) {
    if (rows * columns < 10) throw Exception('Not enough tiles');
    if (_numOfMines >= rows * columns - 9) throw Exception('Too many mines');
    board = List.generate(rows, (index) => List(columns));
  }

  void firstReveal(int startRow, int startCol) {
    initialized = true;
    // Create start area
    getNeighbors(startRow, startCol)
      ..add(TileReference(board, startRow, startCol))
      ..forEach((tileRef) => board[tileRef.row][tileRef.column] = Tile(0));
    // Place mines
    var rand = Random();
    for (int i = 0; i < _numOfMines;) {
      int row = rand.nextInt(board.length), col = rand.nextInt(board[0].length);
      if (board[row][col] == null) {
        board[row][col] = Tile(-1);
        i++;
      }
    }
    // Generate Tile.value for non-mines
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        board[row][col] ??= Tile(0);
        if (board[row][col].value != -1) {
          getNeighbors(row, col).forEach((tRef) {
            if (Tile.from(tRef)?.value == -1) board[row][col].value++;
          });
        }
      }
    }
  }

  @override
  String toString() {
    if (!initialized) return '${board.length}x${board[0].length} empty board';
    String returnVal = "";
    board.forEach((row) {
      row.forEach((tile) => returnVal += "${tile.value < 0 ? 9 : tile.value} ");
      returnVal += '\n';
    });
    return returnVal;
  }

  /// Returns neighboring tiles' references, excluding the specified tile's
  List<TileReference> getNeighbors(int row, int col) {
    List<TileReference> neighbors = [];
    for (int r = row - 1; r <= row + 1; r++) {
      if (r < 0 || r >= board.length) continue;
      for (int c = col - 1; c <= col + 1; c++) {
        if (c < 0 || c >= board[r].length) continue;
        if (r != row || c != col) neighbors.add(TileReference(board, r, c));
      }
    }
    return neighbors;
  }

  /// Returns true for state changed, false for not
  bool toggleTileState(int row, int col) {
    if (gameState != GameState.ongoing) return false;
    switch (board[row][col].state) {
      case TileState.flagged:
        board[row][col].state = TileState.covered;
        return true;
      case TileState.covered:
        board[row][col].state = TileState.flagged;
        return true;
      default:
        return false;
    }
  }

  get gameState {
    if (!initialized) return GameState.ongoing;
    bool hiddenNums = false;
    // We DO NOT use a for each loop here as we will then not be able to return
    for (int r = 0; r < board.length; r++) {
      for (int c = 0; c < board[r].length; c++) {
        final t = board[r][c];
        if (t.value == -1 && t.state == TileState.revealed) {
          board.forEach((row) => row.forEach((t) {
                if (t.state == TileState.flagged) t.state = TileState.covered;
                if (t.value == -1) t.state = TileState.revealed;
              }));
          if (onLose != null) {
            onLose();
            onLose = null;
          }
          return GameState.lost;
        }
        if (t.value >= 0 && t.state != TileState.revealed) hiddenNums = true;
      }
    }
    if (!hiddenNums) {
      if (onWin != null) {
        onWin();
        onWin = null;
      }
      return GameState.won;
    }
    return GameState.ongoing;
  }

  GameState revealTile(int row, int col) {
    if (!initialized) firstReveal(row, col);
    if (gameState != GameState.ongoing ||
        board[row][col].state == TileState.flagged) return gameState;
    board[row][col].state = TileState.revealed;
    if (board[row][col].value == -1) return gameState;
    int numOfMines = 0, numOfFlags = 0;
    getNeighbors(row, col).forEach((tileRef) {
      if (Tile.from(tileRef).value == -1) numOfMines++;
      if (Tile.from(tileRef).state == TileState.flagged) numOfFlags++;
    });
    if (numOfMines == numOfFlags) {
      getNeighbors(row, col).forEach((tileRef) {
        final tile = Tile.from(tileRef);
        if (tile.state == TileState.covered) {
          if (tile.value == 0)
            revealTile(tileRef.row, tileRef.column);
          else
            tile.state = TileState.revealed;
        }
      });
    }
    return gameState; // Update gameState if necessary
  }
}

class TileReference {
  int row;
  int column;
  List<List<Tile>> board; // Store board so we can have a factory in Tile

  TileReference(this.board, this.row, this.column);
}

enum GameState { won, lost, ongoing }

enum TileState { covered, flagged, revealed }

class Tile {
  /// For the tile's underlying value.
  /// -1 for mine, 0 for no mines in vicinity, 1 for 1 mine, etc.
  int value;

  /// The state of this tile (revealed, covered, etc.)
  TileState state;

  Tile(this.value, [this.state = TileState.covered]);

  factory Tile.from(TileReference tRef) => tRef.board[tRef.row][tRef.column];
}
