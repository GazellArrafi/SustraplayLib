import "package:flutter/material.dart";
import "package:sustraplay_abp/components/cardStatistik.dart";

class ShowCardStat extends StatelessWidget {
  ShowCardStat(this.listCardStat);

  final List<CardStatistik> listCardStat;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: listCardStat.length,
      itemBuilder: (context, index) {
        return listCardStat.elementAt(index);
      },
    );
  }
}