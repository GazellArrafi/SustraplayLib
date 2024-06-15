import "package:flutter/material.dart";
import "package:sustraplay_abp/components/showFavorite.dart";
import "package:sustraplay_abp/data/getFavorit.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:go_router/go_router.dart";

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  PageController controller = new PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            margin: EdgeInsets.symmetric(vertical: 40),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    context.pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "My Favorite Game",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 660,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: FutureBuilder(
              future: getFavoritGame(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(!snapshot.data!.isEmpty){
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 630,
                          child: PageView.builder(
                            controller: controller,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ShowFavorite(snapshot.data!.elementAt(index));
                            },
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: controller,
                          count: snapshot.data!.length,
                          effect: WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            type: WormType.normal,
                            activeDotColor: Color(0xFFED8128),
                            dotColor: Color(0xFFCB5C1E),
                          ),
                        ),
                      ],
                    );
                  }else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          color: Colors.white,
                          size: 150,
                        ),
                        Text(
                          "Game not found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            height: 1,
                          ),
                        )
                      ],
                    );
                  }
                }else{
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.halfTriangleDot(
                        color: Colors.white,
                        size: 100,
                      ),
                      Text(
                        "Please Wait...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ); 
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}