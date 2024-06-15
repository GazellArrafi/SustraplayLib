import "package:flutter/material.dart";
import "package:sustraplay_abp/components/boxChoiceSet.dart";
import "package:sustraplay_abp/components/loadingScreen.dart";
import "package:sustraplay_abp/components/showCardGame.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:sustraplay_abp/data/getMostPlay.dart";
import "package:sustraplay_abp/data/getUsers.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController(keepPage: true);
  Map<String, String> user = {};

  @override
  void initState() {
    super.initState();
    getUser().then((value){
      user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snap){
        if(snap.hasData){
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Box Profile
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(26))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Photo Profile & Nama
                      Stack(
                        children: [
                          //Box Photo Profile
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              image: DecorationImage(
                                image: AssetImage("img/profilePic.png")
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 6,
                              )
                            ),
                          ),
                          //Box Nama
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 23, horizontal: 62),
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            height: 34,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            //Nama
                            child: Text(
                              user['name']!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Box Button Favorit, setting, search
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Box Favorit
                          BoxChoiceSet(Icons.favorite, "Favorite", "/favoritePage"),
                          //Box Search
                          BoxChoiceSet(Icons.search, "Search", "/searchPage"),
                          //Box Setting
                          BoxChoiceSet(Icons.settings, "Setting", "/settingPage"),
                        ],
                      ),
                    ],
                  ),
                ),
                //Box Game 1
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(26))
                  ),
                  child: Column(
                    children: [
                      //Show Box Teks Game
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        width: 280,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Text(
                          "Most played amongst gamers",
                          style: TextStyle(
                            // color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      //Show Box Card Game
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: snap.data!.length,
                          itemBuilder: (context, index) {
                            return ShowCardGame(snap.data!.elementAt(index));
                          },
                        )
                      ),
                      //Indikator Page Card Game
                      SmoothPageIndicator(
                        controller: controller,
                        count: snap.data!.length,
                        effect: WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          type: WormType.normal,
                          activeDotColor: Color(0xFFED8128),
                          dotColor: Color(0xFFCB5C1E),
                        ),
                      ),
                    ],
                  ),
                ),
                //Box Game 2
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(26))
                  ),
                ),
              ],
            ),
          );
        }else{
          return LoadingScreen();
        }
      },
    );
  }
}