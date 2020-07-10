import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper/custom_widgets/big_button.dart';
import 'package:minesweeper/game_route_viewmodel.dart';
import 'package:minesweeper/game_route.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(MaterialApp(
    title: 'Minesweeper',
    theme: ThemeData(
      brightness: Brightness.dark,
      sliderTheme: ThemeData.dark()
          .sliderTheme
          .copyWith(valueIndicatorColor: Colors.tealAccent),
    ),
    home: AppHome(),
  ));
}

// todo about page

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minesweeper')),
      body: ListView(
        padding: EdgeInsets.only(bottom: 12.0),
        children: <Widget>[
          BigButton(
            icon: '😀',
            title: 'Easy',
            description: '8x8 Grid, 10 Mines',
            onPressed: () => startGame(context, GameRouteViewModel(8, 6, 8)),
          ),
          BigButton(
            icon: '😐',
            title: 'Medium',
            description: '16x16 Grid, 40 Mines',
            onPressed: () => startGame(context, GameRouteViewModel(16, 16, 40)),
          ),
          BigButton(
            icon: '😲',
            title: 'Hard',
            description: '30x16 Grid, 99 Mines',
            onPressed: () => startGame(context, GameRouteViewModel(30, 16, 99)),
          ),
          BigButton(
            icon: '⚙️',
            title: 'Custom',
            description: 'Create a custom board',
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => _CustomGameDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CustomGameDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomGameDialogState();
}

class _CustomGameDialogState extends State<_CustomGameDialog> {
  double _rows = 4;
  double _columns = 4;
  double _minePercentMin = 1, _minePercentMax = 99, _minePercent = 1;

  @override
  Widget build(BuildContext context) {
    fixMinePercentSlider();
    return AlertDialog(
      title: Text('Custom Game'),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            children: [
              Text('This mode allows you to pick your own game options, '
                  'including the percent of the board '
                  'to be covered by mines.\n'),
              Text('Number of rows'),
              Slider(
                label: '${_rows.round()}',
                min: 4,
                max: 30,
                divisions: 26,
                value: _rows,
                onChanged: (value) => setState(() => _rows = value),
              ),
              Text('Number of columns'),
              Slider(
                label: '${_columns.round()}',
                min: 4,
                max: 30,
                divisions: 26,
                value: _columns,
                onChanged: (value) => setState(() => _columns = value),
              ),
              Text('Mine tile percentage'),
              Slider(
                label: '${_minePercent.round()}',
                divisions: (_minePercentMax - _minePercentMin).round(),
                min: _minePercentMin,
                max: _minePercentMax,
                value: _minePercent,
                onChanged: (value) => setState(() => _minePercent = value),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Start'),
          onPressed: () {
            Navigator.of(context).pop();
            final numOfMines = (_minePercent / 100 * _rows * _columns).round();
            startGame(
                context,
                GameRouteViewModel(
                  _rows.floor(),
                  _columns.floor(),
                  numOfMines,
                ));
          },
        ),
      ],
    );
  }

  void fixMinePercentSlider() {
    final numOfTiles = _rows * _columns;
    _minePercentMin = (100 / numOfTiles).ceilToDouble();
    _minePercentMax = (100 * (numOfTiles - 10) / numOfTiles).floorToDouble();
    if (_minePercent < _minePercentMin) _minePercent = _minePercentMin;
    if (_minePercent > _minePercentMax) _minePercent = _minePercentMax;
  }
}

void startGame(BuildContext context, GameRouteViewModel viewModel) {
  final route = MaterialPageRoute(builder: (context) => GameRoute(viewModel));
  Navigator.push(context, route);
}
