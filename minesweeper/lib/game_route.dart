import 'package:flutter/material.dart';
import 'package:minesweeper/game_route_viewmodel.dart';
import 'package:minesweeper/custom_widgets/bidirectional_scroll.dart';

class GameRoute extends StatefulWidget {
  final GameRouteViewModel viewModel;

  GameRoute(this.viewModel, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameRouteState();
}

class _GameRouteState extends State<GameRoute> {
  static const TILE_SPACING = 5.0;

  @override
  void initState() {
    super.initState();
    widget.viewModel.setCallbacks(setState, showWinDialog, showLoseDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minesweeper'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text('${widget.viewModel.elapsedTime}'),
            ),
          ),
        ],
      ),
      body: BidirectionalScroll(
        scaleMax: 4.0,
        child: Padding(
          padding: EdgeInsets.only(left: TILE_SPACING, top: TILE_SPACING),
          child: Column(
              children: List.generate(widget.viewModel.board.length, (row) {
            return Row(
                children: List.generate(
              widget.viewModel.board[row].length,
              (col) => gameTile(widget.viewModel.board[row][col]),
            ));
          })),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.dispose();
  }

  Widget gameTile(GameTileViewModel tileModel) {
    return Padding(
      padding: EdgeInsets.only(right: TILE_SPACING, bottom: TILE_SPACING),
      child: GestureDetector(
        onTap: () => widget.viewModel.onTilePress(tileModel),
        onLongPress: () => widget.viewModel.onTileLongPress(tileModel),
        child: Container(
          width: 60,
          height: 60,
          color: tileModel.backgroundColor,
          child: Center(
            child: Text(
              tileModel.value,
              style: TextStyle(
                color: GameTileViewModel.TEXT_COLOR,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showWinDialog(String timeElapsed) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You won!'),
          content: Text('It took you $timeElapsed to complete the board.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void showLoseDialog(String timeElapsed) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You lost!'),
          content: Text('You lost after $timeElapsed.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
