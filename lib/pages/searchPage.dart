import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:sustraplay_abp/components/showSearchGame.dart";
import "package:sustraplay_abp/components/cardGame.dart";
import "package:sustraplay_abp/data/getSearchGame.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  PageController controller = new PageController(keepPage: true);
  late Future<List<List<List<CardGame>>>>listSearch;
  String namaGame = "";

  @override
  void initState() {
    listSearch = searchGame(namaGame);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            margin: EdgeInsets.only(top: 40),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    context.pop();
                  },
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 40,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 70,
                  child: TextField(
                    onSubmitted: (value){
                      setState(() {
                        namaGame = value;
                        listSearch = searchGame(namaGame);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 30
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer, 
                          width: 4
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          width: 2,
                          ),
                      ),
                      hintText: "Search Game"
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Text(
                  "Game search results",
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                Text(
                  "You’ve searched for ${namaGame}",
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 25,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 510,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: FutureBuilder(
              future: listSearch,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(!snapshot.data!.isEmpty){
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 485,
                          child: PageView.builder(
                            controller: controller,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ShowSearch(snapshot.data!.elementAt(index));
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
      )
    );
  }
}
