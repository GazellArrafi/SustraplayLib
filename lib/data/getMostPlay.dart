import "package:http/http.dart" as http;
import "dart:convert" as convert;
import "package:mysql_client/mysql_client.dart";

import "package:sustraplay_abp/components/cardGame.dart";

Future<List<List<CardGame>>> fetchData() async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  var dataDb = await conn.execute("SELECT * FROM tbl_peak");

  final resApi = await http.post(
    Uri.parse("https://api.igdb.com/v4/games"),
    headers: {
      "Accept": "application/json",
      "Client-ID": "dssjkvlpsxeqevzscna95z2abuz7ij",
      "Authorization": "Bearer abzvhwb8lacufz91stpyza8w9cjmcy"
    },
    body: 'fields id, cover.*, name; sort rating desc; where release_dates.y < 2020;'
  );

  if(resApi.statusCode == 200){
    var jsonRes = convert.jsonDecode(resApi.body) as List<dynamic>;
    List<List<dynamic>> data = [];
    List<List<CardGame>> listCardGame = []; 

    for(var i = 0; i < jsonRes.length; i++){
      for(var j in dataDb.rows){
        if(jsonRes[i]['id'].toString() == j.assoc()['id_game'].toString()){
          jsonRes[i]['peak'] = j.assoc()['peak_player'].toString();
          jsonRes[i]['inGame'] = j.assoc()['in_game_peak'].toString();
          break;
        }else{
          jsonRes[i]['peak'] = "0";
          jsonRes[i]['inGame'] = "0";
        }
      }
    }

    if(jsonRes.length % 2 == 0){
      var idx = 0;
      for(var i = 0; i < jsonRes.length / 2; i++){
        listCardGame.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
        idx += 2;
      }
    }else{
      var idx = 0;
      for(var i = 0; i < (jsonRes.length - 1) / 2; i++){
        listCardGame.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
        idx += 2;
      }
      data.add([jsonRes[idx + 1]]);
    }

    return listCardGame;
  }else{
    throw Exception("Error code: ${resApi.statusCode}");
  }
}