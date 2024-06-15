import "package:http/http.dart" as http;
import "dart:convert" as convert;
import "package:mysql_client/mysql_client.dart";
import "package:intl/intl.dart";

Future<dynamic> getGame(String idGame) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

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
    var dataDb = await conn.execute("SELECT * FROM tbl_peak WHERE id_game = ${idGame}");
    var dataApi = convert.jsonDecode(resApi.body)[0];
    if(!dataDb.isEmpty){
      for(var data in dataDb.rows){
        dataApi['peak'] = data.assoc()['peak_player'].toString();
        dataApi['inGame'] = data.assoc()['in_game_peak'].toString();
      }
    }else{
      dataApi['peak'] = "0";
      dataApi['inGame'] = "0";
    }
    return dataApi; 
  }else{
    throw Exception("Error code: ${resApi.statusCode}");
  }
}

Future<List<dynamic>> getStatistikGame(String idGame) async{
  List<Map<String, List<String>>> statistikData = [];

  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  var dataDb = await conn.execute("SELECT * FROM tbl_statistik WHERE id_game = ${idGame} ORDER BY date_statistik ASC");

  for(var data in dataDb.rows){
    String date = data.assoc()['date_statistik'].toString();
    String peak = data.assoc()['peak_player'].toString();
    String gain = data.assoc()['gain_player'].toString();

    statistikData.add({date: [peak, gain], 'id': [data.assoc()['id_statistik'].toString()]});
  }

  return statistikData;
}

Future<void> addStatGame(String peak, String idGame, DateTime date) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  late bool cek;
  await conn.execute("SELECT * FROM tbl_statistik WHERE id_game = ${idGame}").then(
    (value){
      if(value.numOfRows == 0){
        cek = true;
      }else{
        cek = false;
      }
    }
  );

  String strDate = DateFormat("yyyy-MM-dd").format(date);
  if(cek){
    await conn.execute("INSERT INTO tbl_statistik(id_game, date_statistik, peak_player, gain_player) VALUES(${idGame}, '${strDate}', ${peak}, 0)");
  }else{
    late int lastPeak;
    await conn.execute("SELECT * FROM tbl_statistik WHERE id_game = ${idGame} ORDER BY date_statistik DESC").then(
      (value){
        for(var data in value.rows){
          lastPeak = int.parse(data.assoc()['peak_player'].toString());
          break;
        }
      }
    );

    await conn.execute("INSERT INTO tbl_statistik(id_game, date_statistik, peak_player, gain_player) VALUES(${idGame}, '${strDate}', ${peak}, ${int.parse(peak) - lastPeak})");
  }
}

Future<void> delStatGame(String idStat) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  await conn.execute("DELETE FROM tbl_statistik WHERE id_statistik = ${idStat}");
}

Future<void> updetStatGame(String idStat, String peak, DateTime newDate) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  await conn.execute("UPDATE tbl_statistik SET date_statistik = '${DateFormat('yyyy-MM-dd').format(newDate)}', peak_player = ${peak} WHERE id_statistik = ${idStat}");
}