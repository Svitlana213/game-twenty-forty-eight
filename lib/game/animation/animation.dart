import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/tile.dart';
import '../../utils/utils.dart';
import '../widgets/boardWidget.dart';
import '../tileBox.dart';

class AnimatedTileWidget extends AnimatedWidget{
  final Tile tile;
  final BoardWidgetState state;

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
