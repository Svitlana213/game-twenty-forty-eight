import 'package:flutter/cupertino.dart';
import '../../model/tile.dart';
import '../animation/animation.dart';
import 'boardWidget.dart';

class TileWidget extends StatefulWidget{
  final Tile tile;
  final BoardWidgetState state;

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