import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/boardWidget.dart';

class EndGameScreen {
  static void show(BuildContext context, BoardWidgetState state, {bool isWin = false}){
    showDialog(
      context: context,
      builder: (context) => Material(
          color: Color.fromRGBO(255, 255, 255, 0.2),
          child: Container(
            width: 50,
            height: 50,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                isWin ? 'Congratulations!' : 'Game Over',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              content: Text(
                isWin ? "You've reached 2048!" : "Try again to reach 2048!",
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      state.newGame();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(250, 143, 122, 102),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),
                    child: Text('New game', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          )
      ),

    );
  }
}