import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class BoxChoiceSet extends StatelessWidget {
  BoxChoiceSet(this.icon, this.teks, this.navi);
  final String navi;
  final IconData icon;
  final String teks;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(navi);
      },
      child: Column(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 54,
            ),
          ),
          Text(
            teks,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}