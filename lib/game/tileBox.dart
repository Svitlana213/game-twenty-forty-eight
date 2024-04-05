import 'package:flutter/cupertino.dart';

class TileBox extends StatelessWidget{
  final double left;
  final double top;
  final double size;
  final Color color;
  final String text;

  const TileBox({
    super.key,
    required this.left,
    required this.top,
    required this.size,
    required this.color,
    required this.text,
  });

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
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
        ),
      ),
    );
  }
}