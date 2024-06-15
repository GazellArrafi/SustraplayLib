import "package:mysql_client/mysql_client.dart";
import "package:bcrypt/bcrypt.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<Map<String, String>> login(String username, String password) async{
  final conn = await MySQLConnection.createConnection(
    host: "sustratistik-tubes-abp-statistikgame.a.aivencloud.com", 
    port: 23557, 
    userName: "avnadmin", 
    password: "AVNS_hXDUb6M4FUMgJtQaYl7",
    databaseName: "defaultdb",
  );
  await conn.connect();
  
  var resDb = await conn.execute("SELECT * FROM users WHERE username = '${username}'");

  if(!resDb.isEmpty){
    for(var data in resDb.rows){
      if(BCrypt.checkpw(password, data.assoc()['password'].toString())){
        Map<String, String> temp = {};
        
        temp['id'] = data.assoc()['id'].toString();
        temp['name'] = data.assoc()['name'].toString();
        temp['email'] = data.assoc()['email'].toString();
        temp['username'] = data.assoc()['username'].toString();
        temp['password'] = data.assoc()['password'].toString();
        temp['role'] = data.assoc()['role'].toString();

        return temp;
      }
    }
    return {};
  }else{
    return {};
  }
}

Future<void> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();

  await pref.remove('id');
  await pref.remove('name');
  await pref.remove('email');
  await pref.remove('username');
  await pref.remove('password');
  await pref.remove('role');
}

Future<Map<String, String>> getUser() async{
  SharedPreferences pref = await SharedPreferences.getInstance();

  Map<String, String> temp = {};
  
  if(await pref.getString("id") != null){
    temp['id'] = await pref.getString("id").toString();
    temp['name'] = await pref.getString("name").toString();
    temp['email'] = await pref.getString("email").toString();
    temp['username'] = await pref.getString("username").toString();
    temp['password'] = await pref.getString("password").toString();
    temp['role'] = await pref.getString("role").toString();
  }
  
  return temp;
}

