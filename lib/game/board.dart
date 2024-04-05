import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import '../model/model.dart';
import 'endGame.dart';
import 'tileWidget.dart';

class BoardWidget extends StatefulWidget{
  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {
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
      gameOver = _board.gameOver();
    });
  }

  void gameover(){
    setState(() {
      if(_board.gameOver()){
        EndGameScreen.show(context, this);
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

    List<TileWidget> _tileWidgets = [];

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

    children.add(Game(state: this,));
    children.addAll(_tileWidgets);

    return Scaffold(
      backgroundColor: Color.fromARGB(250, 232, 220, 202),
      body: Column(
        children:[
          Container(
            child: Column(
              children:[
                SizedBox(height: 50),
                Center(
                  child: Text('2048 game', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Score: ${_board.score.toString()}', style: TextStyle(color: Colors.black, fontSize: 24),),
                    ElevatedButton(
                      onPressed: () {

                        newGame();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(250, 143, 122, 102),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      child: Text('New game', style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 50),
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
      ),

    );
  }
}