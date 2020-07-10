import 'package:minesweeper/game_model.dart';

void main() {
  // todo expand board test & automate with lots of values
  // todo also go through game play
  var board = Board(5, 5, 5);
  board.revealTile(0, 0);
  print(board);
}