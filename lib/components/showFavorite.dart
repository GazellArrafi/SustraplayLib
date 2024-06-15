import "package:flutter/material.dart";
import "package:sustraplay_abp/components/cardGame.dart";
import "package:sustraplay_abp/components/showCardGame.dart";

class ShowFavorite extends StatelessWidget {
  ShowFavorite(this.listCardGame);

  final List<List<CardGame>> listCardGame;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        itemCount: listCardGame.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 230,
            child: ShowCardGame(listCardGame[index]),
          );
        },
      ),
    );
  }
}