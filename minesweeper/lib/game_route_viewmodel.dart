import 'dart:async';
import 'package:minesweeper/game_model.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class GameRouteViewModel {
  final Stopwatch stopwatch = Stopwatch();
  final Board _board;
  Timer timer;
  Function rebuildUI;

  GameRouteViewModel(int rows, int columns, int mines)
      : _board = Board(rows, columns, mines);

  void setCallbacks(Function rebuildUI, Function win, Function lose) {
    this.rebuildUI = rebuildUI;
    _board.onWin = () => win(calcElapsedTime());
    _board.onLose = () => lose(calcElapsedTime());
  }

  void dispose() {
    timer?.cancel();
    stopwatch?.stop();
  }

  String calcElapsedTime() {
    stopwatch.stop();
    timer?.cancel();
    return stopwatch.elapsed.toString();
  }

  void onTilePress(GameTileViewModel tileModel) {
    if (_board.gameState != GameState.ongoing) return;
    if (!_board.initialized) {
      stopwatch.start();
      timer = Timer.periodic(Duration(seconds: 1), (timer) => rebuildUI(() {}));
    }
    rebuildUI(() {
      _board.revealTile(tileModel.row, tileModel.col);
    });
  }

  void onTileLongPress(GameTileViewModel tileModel) {
    if (_board.gameState != GameState.ongoing || !_board.initialized) return;
    HapticFeedback.vibrate();
    rebuildUI(() {
      _board.toggleTileState(tileModel.row, tileModel.col);
    });
  }

  get board {
    return List.generate(_board.board.length, (row) {
      return List.generate(_board.board[row].length, (col) {
        return GameTileViewModel(_board.board[row][col], row, col);
      });
    });
  }

  get elapsedTime {
    String timeStr = '';
    timeStr += (stopwatch.elapsedMilliseconds / 60000).floor().toString();
    final seconds = ((stopwatch.elapsedMilliseconds % 60000) / 1000).floor();
    timeStr += ((seconds < 10) ? ':0' : ':') + seconds.toString();
    return timeStr;
  }
}

class GameTileViewModel {
  static const FLAG = '🏴';
  static const MINE = '💣';
  static const LIGHT_BACKGROUND = Color.fromARGB(255, 222, 222, 220);
  static const DARK_BACKGROUND = Color.fromARGB(255, 186, 189, 182);
  static const TEXT_COLOR = Color.fromARGB(255, 46, 52, 54);
  final int row, col;
  Color backgroundColor;
  String value;

  GameTileViewModel(Tile tile, this.row, this.col) {
    if (tile == null) {
      backgroundColor = DARK_BACKGROUND;
      value = '';
      return;
    }
    switch (tile.state) {
      case TileState.flagged:
        backgroundColor = DARK_BACKGROUND;
        value = FLAG;
        break;
      case TileState.covered:
        backgroundColor = DARK_BACKGROUND;
        value = '';
        break;
      case TileState.revealed:
        switch (tile.value) {
          case -1:
            backgroundColor = DARK_BACKGROUND;
            value = MINE;
            break;
          case 0:
            backgroundColor = LIGHT_BACKGROUND;
            value = '';
            break;
          default:
            backgroundColor = LIGHT_BACKGROUND;
            value = tile.value.toString();
            break;
        }
        break;
    }
  }
}
