import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game/board.dart';
import 'game/tileBox.dart';

class Game extends StatelessWidget{
  final BoardWidgetState state;

  const Game({required this.state});

  @override
  Widget build(BuildContext context){
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) / state.column;

    List<TileBox> backgroundBox = [];

    for(int r = 0; r < state.row; r++){
      for(int c = 0; c < state.column; c++){
        TileBox tile = TileBox(
            left: c * width * state.tilePadding * (c + 1),
            top: r * width * state.tilePadding * (r + 1),
            size: width,
            color: Color.fromARGB(250, 205, 193, 180),
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
          color: Color.fromARGB(250, 205, 193, 180),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Stack(
          fit: StackFit.expand,
          children: backgroundBox,
        ),
      ),
    );
  }
}



