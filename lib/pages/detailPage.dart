import "package:flutter/material.dart";
import "package:sustraplay_abp/components/loadingScreen.dart";
import "package:sustraplay_abp/data/getDetailGame.dart";
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:card_swiper/card_swiper.dart';
import "package:go_router/go_router.dart";

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.idGame});

  final String idGame;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDetailGame(idGame),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          String img = snapshot.data![0].containsKey('cover') ? snapshot.data![0]['cover']['url'] : "//dummyimage.com/300x300/fff/000&text=Not+Found";
          String sum = snapshot.data![0].containsKey('summary') ? snapshot.data![0]['summary'] : "No data";
          String yt = snapshot.data![0].containsKey('videos') ? snapshot.data![0]['videos'][0]['video_id'] : "";
          List<Image> listArts = [];
          late YoutubePlayerController ytController;
          
          if(yt != ""){
            ytController = YoutubePlayerController(
              initialVideoId: yt,
              flags: YoutubePlayerFlags(
                mute: false,
                autoPlay: false,
              )
            );
          }

          if(snapshot.data![0].containsKey('artworks')){
            for(var data in snapshot.data![0]['artworks']){
              listArts.add(Image.network("https:"+data['url'], fit: BoxFit.fill,));
            }
          }

          Widget aboutGame(){
            return Column(
              children: [
                Text(
                  "Artworks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                listArts.isEmpty ? 
                Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white,
                  size: 70,
                ) :
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Swiper(
                    itemCount: listArts.length,
                    autoplay: false,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    itemBuilder: (context, index) {
                      return listArts[index];
                    },
                  ),
                ),
                Text(
                  "About Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  child: SingleChildScrollView(
                    child: Text(
                      sum,
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            );
          }

          Widget tableDetail(){
            return Column(
              children: [
                Text(
                  "Detail Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: 40,
                        color: Color(0xFFCB5C1E),
                      ),
                      Container(
                        height: 40,
                        color: Color(0xFF984F26),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(left: 10, right: 10, top: 38, bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: (){
                            context.pop();
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          snapshot.data![0]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: yt != ""
                    ? 
                    YoutubePlayer(
                      controller: ytController, 
                      showVideoProgressIndicator: true,
                    )
                    : 
                    Image.network(
                      "https:"+img,
                      fit: BoxFit.cover,
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 460,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: aboutGame(),
                  ),
                ],
              ),
            ),
          );
        }else{
          return LoadingScreen();
        }
      },
    );
  }
}