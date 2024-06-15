import "package:mysql_client/mysql_client.dart";
import "package:sustraplay_abp/components/cardGame.dart";
import "package:sustraplay_abp/data/getSearchGame.dart";
import "package:sustraplay_abp/data/getUsers.dart";

Future<List<Map<String, String>>> getFavorit() async {
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com",
    port: 23557,
    userName: "avnadmin",
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  late Map<String, String> users;
  await getUser().then((value) {
    users = value;
  });

  var resDb = await conn
      .execute("SELECT * FROM tbl_favorit WHERE id_users = ${users['id']}");

  if (!resDb.isEmpty) {
    List<Map<String, String>> listDataFav = [];
    for (var data in resDb.rows) {
      Map<String, String> temp = {};

      temp['id_favorit'] = data.assoc()['id_favorit']!;
      temp['id_game'] = data.assoc()['id_game']!;

      listDataFav.add(temp);
    }

    return listDataFav;
  }
  return [];
}

Future<List<List<List<CardGame>>>> getFavoritGame() async {
  List<Map<String, String>> listFav = [];

  await getFavorit().then((value) {
    listFav = value;
  });

  List<dynamic> jsonRes = [];

  if (!listFav.isEmpty) {
    for (var fav in listFav) {
      jsonRes.add(await searchIdGame(fav['id_game']!));
    }

    List<List<List<CardGame>>> listCardGame = [[]];
    List<List<CardGame>> tempListCard = [];
    if (jsonRes.length % 2 == 0) {
      var idx = 0;
      for (var i = 0; i < jsonRes.length / 2; i++) {
        tempListCard.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
        idx += 2;
      }
    } else {
      var idx = 0;
      for (var i = 0; i < (jsonRes.length - 1) ~/ 2; i++) {
        tempListCard.add([CardGame(jsonRes[idx]), CardGame(jsonRes[idx + 1])]);
        idx += 2;
      }
      tempListCard.add([jsonRes[idx + 1]]);
    }

    var idx = 0;
    var i = 0;
    for (var j = 0; j < tempListCard.length; j++) {
      if (j != tempListCard.length - 1) {
        if (i < 3) {
          listCardGame[idx].add(tempListCard[j]);
          i++;
        } else {
          listCardGame.add([]);

          idx++;
          listCardGame[idx].add(tempListCard[j]);
          i = 1;
        }
      } else {
        listCardGame[idx].add(tempListCard[j]);
      }
    }
    return listCardGame;
  }
  return [];
}

Future<bool> cekFavoritGame(String idUsers, String idGame) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com",
    port: 23557,
    userName: "avnadmin",
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();

  var resDb = await conn.execute("SELECT * FROM tbl_favorit WHERE id_game = ${idGame} AND id_users = ${idUsers}");
  
  return resDb.numOfRows == 0;
}

Future<void> deleteFavorit(String idGame, String idUsers) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com",
    port: 23557,
    userName: "avnadmin",
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();
  await conn.execute("DELETE FROM tbl_favorit WHERE id_game = ${idGame} AND id_users = ${idUsers}");
}

Future<void> addFavorit(String idGame, String idUsers) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com",
    port: 23557,
    userName: "avnadmin",
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();
  await conn.execute("INSERT INTO tbl_favorit(id_game, id_users) VALUES(${idGame}, ${idUsers})");
}