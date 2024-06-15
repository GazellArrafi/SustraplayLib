import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sustraplay_abp/components/loadingScreen.dart";
import "package:sustraplay_abp/components/cardStatistik.dart";
import "package:sustraplay_abp/components/showCardStat.dart";
import "package:sustraplay_abp/components/showGraph.dart";
import "package:sustraplay_abp/data/getFavorit.dart";
import "package:sustraplay_abp/data/getStatistikData.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import 'package:fl_chart/fl_chart.dart';
import "package:intl/intl.dart";
import "package:go_router/go_router.dart";
import "package:flutter_dropdown_alert/alert_controller.dart";
import "package:flutter_dropdown_alert/model/data_alert.dart";

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key, required this.idGame});

  final String idGame;
  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  PageController controller = new PageController(keepPage: true);
  DateTime selectDate = new DateTime.now();
  DateTime inputDate = new DateTime.now();
  List<List<CardStatistik>> listCardStat = [];
  List<FlSpot> listSpot = [];
  String inputPeak = "";
  String inputGain = "";
  late bool cekFav;
  late String idUsers;
  late String role;
  late Future<dynamic> dataGame;
  late Future<dynamic> listStat;

  Future<void> loadData() async{
    setState(() {
      dataGame = getGame(widget.idGame);
      listStat = getStatistikGame(widget.idGame);
    });
  }
  
  Future<void> setCekFav() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    idUsers = await pref.getString('id').toString();
    role = await pref.getString('role').toString();
    cekFav = await cekFavoritGame(idUsers, widget.idGame);
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    setCekFav();
    loadData();
  }

  void setStatData(List<Map<String, List<String>>> snap, String year){
    listCardStat.clear();
    listSpot.clear();
    List<Map<String, List<String>>> tempStat = [];
    List<List<Map<String, List<String>>>> statData = [];
    
    for(var data in snap){
      if(data.keys.toString().substring(1, 5) == year){
        tempStat.add(data);
      }
    }

    for(var data in tempStat){
      DateTime date = DateFormat('yyyy-MM-dd').parse(data.keys.toString().substring(1, data.keys.toString().length - 1));
      listSpot.add(FlSpot(double.parse(DateFormat.M().format(date)), double.parse(data.values.elementAt(0)[0])));
    }

    var i = 0;
    List<Map<String, List<String>>> tempData = [];

    for(var data in tempStat){
      if(i < 3){
        tempData.add(data);
        i++;
      }else{
        statData.add(tempData);

        tempData = [data];
        i = 1;
      }
    }

    statData.add(tempData);

    for(var data in statData){
      List<CardStatistik> tempListCard = [];

      for(var temp in data){
        tempListCard.add(CardStatistik(temp));
      }

      listCardStat.add(tempListCard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([dataGame, listStat]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData){
          String img = snapshot.data![0].containsKey('cover') ? snapshot.data![0]['cover']['url'] : "//dummyimage.com/300x300/fff/000&text=Not+Found";
          String sum = snapshot.data![0].containsKey('summary') ? snapshot.data![0]['summary'] : "No data";
          setStatData(snapshot.data![1] as List<Map<String, List<String>>>, selectDate.year.toString());
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
                size: 35,
              ),
              title: Text(
                snapshot.data![0]['name'],
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: (){
                    if(cekFav){
                      addFavorit(widget.idGame, idUsers);
                      setState(() {
                        cekFav = false;
                      });
                    }else{
                      deleteFavorit(widget.idGame, idUsers);
                      setState(() {
                        cekFav = true;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: cekFav ? 
                    Icon(
                      Icons.favorite_outline_rounded,
                      size: 36,
                    ) : 
                    Icon(
                      Icons.favorite_rounded,
                      color: Colors.redAccent,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https:"+img,
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About Game",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    Container(
                                      height: 94, 
                                      child: SingleChildScrollView(
                                        child: Text(
                                          sum,
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Box Peak
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              //Text Peak
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.isEmpty ? snapshot.data![0]['peak'].toString() : "0",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        "Peak",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.isEmpty ? snapshot.data![0]['inGame'].toString() : "0",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        "In-Game",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                context.push('/detailPage/${widget.idGame}');
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 34,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text(
                                    "Detail Game",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Showw Graph
                      ShowGraph(listSpot),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 390,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      //Button Change year
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            width: 170,
                            height: 25,
                            child: FloatingActionButton(
                              heroTag: "btnChangeYear",
                              onPressed: () async{
                                final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: selectDate,
                                  firstDate: DateTime(1958),
                                  lastDate: DateTime(3000)
                                );
                                if(dateTime != null){
                                  setState(() {
                                    selectDate = dateTime;
                                    setStatData(snapshot.data![1] as List<Map<String, List<String>>>, selectDate.year.toString());
                                  });
                                }
                              },
                              child: Text(
                                "Change Year",
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          //Button add data peak
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15, left: 10),
                            width: 120,
                            height: 25,
                            child: FloatingActionButton(
                              heroTag: "btnToAdd",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    StateSetter _setState;
                                    return AlertDialog(
                                      title: Text(
                                        "Add Data Peak",
                                        style: TextStyle(
                                          // color: Colors.black,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: StatefulBuilder(
                                        builder: (context, setState) {
                                          _setState = setState;
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextField(
                                                onChanged: (value){
                                                  setState(() {
                                                    inputPeak = value;
                                                  });
                                                },
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                                  hintText: "Peak"
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Date Picked:",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat("MMMM - yyyy").format(inputDate),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1,
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                width: 160,
                                                margin: EdgeInsets.symmetric(vertical: 10),
                                                child: FloatingActionButton(
                                                  heroTag: "btnSetYearMonth",
                                                  onPressed: () async{
                                                    final DateTime? dateTime = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1958),
                                                      lastDate: DateTime(3000)
                                                    );
                                                    if(dateTime != null){
                                                      _setState(() {
                                                        inputDate = dateTime;
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    "Pick a Date",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 100,
                                              child: FloatingActionButton(
                                                heroTag: "btnCancleStat",
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancle",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              width: 100,
                                              child: FloatingActionButton(
                                                heroTag: "btnAddStat",
                                                onPressed: () async {
                                                  if(inputPeak != ""){
                                                    addStatGame(inputPeak, widget.idGame, inputDate);
                                                    loadData();
                                                    setState(() {
                                                      setStatData(snapshot.data![1] as List<Map<String, List<String>>>, selectDate.year.toString());
                                                    });
                                                    AlertController.show("Success", "Data has been added", TypeAlert.success);
                                                    Navigator.pop(context);
                                                  }else{
                                                    AlertController.show("Warning!", "Please fill in peak first", TypeAlert.warning);
                                                  }
                                                },
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Add Peak",
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${selectDate.year} Peak Data",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Last update: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "1 April 2024",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ],
                      ),
                      //Box Statistik
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: listCardStat.length,
                          itemBuilder: (context, index) {
                            return ShowCardStat(listCardStat.elementAt(index));
                          },
                        )
                      ),
                      //Indikator Page Card Game
                      SmoothPageIndicator(
                        controller: controller,
                        count: listCardStat.length,
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