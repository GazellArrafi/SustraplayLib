import "package:http/http.dart" as http;
import "dart:convert" as convert;

import "package:sustraplay_abp/components/cardGame.dart";
import "package:mysql_client/mysql_client.dart";

Future<dynamic> searchIdGame(String idGame) async{
  final resApi = await http.post(
    Uri.parse("https://api.igdb.com/v4/games"),
    headers: {
      "Accept": "application/json",
      "Client-ID": "dssjkvlpsxeqevzscna95z2abuz7ij",
      "Authorization": "Bearer abzvhwb8lacufz91stpyza8w9cjmcy"
    },
    body: 'fields id, cover.*, name, summary; where id = ${idGame};'
  );

  if(resApi.statusCode == 200){
    var jsonRes = convert.jsonDecode(resApi.body) as List<dynamic>;

    final conn = await MySQLConnection.createConnection(
      host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
      port: 23557, 
      userName: "avnadmin", 
      password: "AVNS_hXDUb6M4FUMgJtQaYl7",
      databaseName: "defaultdb",
    );
    await conn.connect();

    var dataDb = await conn.execute("SELECT * FROM tbl_peak");

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

    return jsonRes.first;
  }else{
    throw Exception("Error code: ${resApi.statusCode}");
  }
}

Future<List<List<List<CardGame>>>> searchGame(String namaGame) async{
  final resApi = await http.post(
    Uri.parse("https://api.igdb.com/v4/games"),
    headers: {
      "Accept": "application/json",
      "Client-ID": "dssjkvlpsxeqevzscna95z2abuz7ij",
      "Authorization": "Bearer abzvhwb8lacufz91stpyza8w9cjmcy"
    },
    body: 'fields id, cover.*, name; where name ~ "${namaGame}"*; limit 20;'
  );

  if(resApi.statusCode == 200){
    List<List<List<CardGame>>> listCardGame = [[]];

    final conn = await MySQLConnection.createConnection(
      host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
      port: 23557, 
      userName: "avnadmin", 
      password: "AVNS_hXDUb6M4FUMgJtQaYl7",
      databaseName: "defaultdb",
    );
    await conn.connect();

    var dataDb = await conn.execute("SELECT * FROM tbl_peak");

    if(namaGame != ""){
      var jsonRes = convert.jsonDecode(resApi.body) as List<dynamic>;

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

      List<List<CardGame>> tempListCard = [];
      if(jsonRes.length % 2 == 0){
        var idx = 0;
        for(var i = 0; i < jsonRes.length / 2; i++){
          tempListCard.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
          idx += 2;
        }
      }else{
        var idx = 0;
        for(var i = 0; i < (jsonRes.length - 1) / 2; i++){
          tempListCard.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
          idx += 2;
        }
        tempListCard.add([jsonRes[idx + 1]]);
      }

      var idx = 0;
      var i = 0;
      for(var j = 0; j < tempListCard.length; j++){
        if(j != tempListCard.length - 1){
          if(i < 2){
            listCardGame[idx].add(tempListCard[j]);
            i++;
          }else{
            listCardGame.add([]);

            idx++;
            listCardGame[idx].add(tempListCard[j]);
            i = 1;
          }
        }else{
          listCardGame[idx].add(tempListCard[j]);
        }
      }
      return listCardGame;
    }else{
      return [];
    }
  }else{
    throw Exception("Error code: ${resApi.statusCode}");
  }
}