import "package:flutter/material.dart";
import "package:sustraplay_abp/components/cardGame.dart";

class ShowCardGame extends StatelessWidget {
  ShowCardGame(this.listCardGame);

  final List<CardGame> listCardGame;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.837,
        crossAxisSpacing: 10,
      ),
      itemCount: listCardGame.length,
      itemBuilder: (context, index) {
        return listCardGame.elementAt(index);
      },
    );
  }
}