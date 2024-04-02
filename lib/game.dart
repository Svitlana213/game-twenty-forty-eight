import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';
import '../utils/utils.dart';

class Game extends StatelessWidget{
  final _BoardWidgetState state;

  const Game({required this.state});

  @override
  Widget build(BuildContext context){
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) / state.column;

    // List<TileBox> backgroundBox = List<TileBox>();
    List<TileBox> backgroundBox = [];

    for(int r = 0; r < state.row; r++){
      for(int c = 0; c < state.column; c++){
        TileBox tile = TileBox(
            left: c * width * state.tilePadding * (c + 1),
            top: r * width * state.tilePadding * (r + 1),
            size: width,
            color: Colors.white38,
            text: '',
        );
        backgroundBox.add(tile);
      }
    }
    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        width: state.boardSize().width,
        height: state.boardSize().width,
        decoration: BoxDecoration(
          color: Colors.white38
        ),
        child: Stack(
          fit: StackFit.expand,
          children: backgroundBox,
        ),
      ),
    );
  }
}

class BoardWidget extends StatefulWidget{
  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late Board _board;
  late int row;
  late int column;
  late bool _isMoving;
  late bool gameOver;
  final double tilePadding = 5.0;
  late MediaQueryData _queryData;

  @override
  void initState() {
    super.initState();

    row = 4;
    column = 4;
    _isMoving = false;
    gameOver = false;

    _board = Board(row, column);
    newGame();
  }

  void newGame() {
    setState(() {
      _board.initBoard();
      gameOver = false;
    });
  }

  void gameover(){
    setState(() {
      if(_board.gameOver()){
        gameOver = true;
      }
    });
  }

  Size boardSize() {
    Size size = _queryData.size;
    return Size(size.width, size.width);
  }
  @override
  Widget build(BuildContext context){
    _queryData = MediaQuery.of(context);

    // List<TileWidget> _tileWidgets = List<TileWidget>();
    List<TileWidget> _tileWidgets = [];

    // for (int r = 0; r < row; ++r) {
    //   for (int c = 0; c < column; ++c) {
    //     _tileWidgets.add(TileWidget(tile: _board.getTile(r, c), state: this));
    //   }
    // }

    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _tileWidgets.add(TileWidget(
          key: UniqueKey(),
          tile: _board.getTile(r, c),
          state: this,
        ));
      }
    }

    List<Widget> children = List<Widget>.empty(growable: true);
    // List<Widget> children = [];

    children.add(Game(state: this,));
    children.addAll(_tileWidgets);

    return ListView(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    color: Colors.cyan,
                    width: 100.0,
                    height: 60.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Score: '),
                          Text(_board.score.toString())
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      newGame();
                    },
                    child: Container(
                      width: 100.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.orange,
                      ),
                      child: Center(
                        child: Text('New game'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: Opacity(
                opacity: gameOver ? 0.0 : 1.0,
                child: Center(
                  child: Text('Game over'),
                ),
              ),
            ),
            Container(
              width: _queryData.size.width,
              height: _queryData.size.width,
              child: GestureDetector(
                onVerticalDragUpdate: (detail) {
                  if (detail.delta.distance == 0 || _isMoving) {
                    return;
                  }
                  _isMoving = true;
                  if (detail.delta.direction > 0) {
                    setState(() {
                      _board.moveDown();
                      gameover();
                    });
                  } else {
                    setState(() {
                      _board.moveUp();
                    });
                  }
                },
                onVerticalDragEnd: (detail) {
                  _isMoving = false;
                },
                onVerticalDragCancel: () {
                  _isMoving = false;
                },
                onHorizontalDragUpdate: (detail) {
                  if (detail.delta.distance == 0 || _isMoving) {
                    return;
                  }
                  _isMoving = true;
                  if (detail.delta.direction > 0) {
                    setState(() {
                      _board.moveLeft();
                    });
                  } else {
                    setState(() {
                      _board.moveRight();
                    });
                  }
                },
                onHorizontalDragEnd: (detail) {
                  _isMoving = false;
                },
                onHorizontalDragCancel: () {
                  _isMoving = false;
                },
                child: Stack(
                  children: children,
                ),
              ),
            ),
          ],
        );
  }
}

class TileWidget extends StatefulWidget{
  final Tile tile;
  final _BoardWidgetState state;

  const TileWidget({required Key key, required this.tile, required this.state}) : super(key:key);

  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        microseconds: 200,
      ),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.tile.isNew && !widget.tile.isEmpty()){
      controller.reset();
      controller.forward();
      widget.tile.isNew = false;
    }else{
      controller.animateTo(1.0);
    }

    return AnimatedTileWidget(
      tile: widget.tile,
      state: widget.state,
      animation: animation,
      key: UniqueKey(),
    );
  }
}

class AnimatedTileWidget extends AnimatedWidget{
  final Tile tile;
  final _BoardWidgetState state;

  AnimatedTileWidget(
      {required Key key, required this.tile, required this.state, required Animation<double>animation})
      : super(key: key, listenable: animation);


  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding)/state.column;

    if(tile.value == 0){
      return Container(

      );
    }else {
      return TileBox(
        left: (tile.column * width + state.tilePadding * (tile.column + 1)) +
            width / 2 * (1 - animationValue),
        top: tile.row * width + state.tilePadding * (tile.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: tileColors[tile.value] ?? Colors.white,
        text: '${tile.value}',
      );
    }
  }
}


class TileBox extends StatelessWidget{
  final double left;
  final double top;
  final double size;
  final Color color;
  final String text;

  const TileBox({super.key, required this.left, required this.top, required this.size, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

}