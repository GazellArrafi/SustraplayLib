import "package:http/http.dart" as http;
import "dart:convert" as convert;

Future<List<dynamic>> getDetailGame(String idGame) async{
  final resApi = await http.post(
    Uri.parse("https://api.igdb.com/v4/games"),
    headers: {
      "Accept": "application/json",
      "Client-ID": "dssjkvlpsxeqevzscna95z2abuz7ij",
      "Authorization": "Bearer abzvhwb8lacufz91stpyza8w9cjmcy"
    },
    body: 'fields id, name, summary, age_ratings.rating, artworks.*, cover.*, first_release_date, genres.*, involved_companies.*, platforms.*, videos.*, game_engines.name; where id = ${idGame};'
  );

  if(resApi.statusCode == 200){
    var dataApi = convert.jsonDecode(resApi.body);

    if(dataApi != []){
      return dataApi;
    }
    return [];
  }else{
    throw Exception("Error code: ${resApi.statusCode}");
  }
}