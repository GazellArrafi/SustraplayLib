import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class CardGame extends StatelessWidget {
  CardGame(this.data);

  final dynamic data;
  @override
  Widget build(BuildContext context) {
    String url = data['cover'] == null ? "//dummyimage.com/300x300/fff/000&text=Not+Found" : data['cover']['url'];
    return GestureDetector(
      onTap: (){
        context.push('/statistikPage/${data['id']}');
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https:"+url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.2, 0.8],
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, right: 5, left: 5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Nama Game
                Text(
                  data['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Teks Peak
                    Column(
                      children: [
                        Text(
                          "Peak",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1
                          ),
                        ),
                        Text(
                          data['peak'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1
                          ),
                        ),
                      ],
                    ),
                    //Teks In-Game
                    Column(
                      children: [
                        Text(
                          "In-Game",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1
                          ),
                        ),
                        Text(
                          data['inGame'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
