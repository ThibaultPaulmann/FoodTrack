import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageHelper {
  static String api1 =
      'https://customsearch.googleapis.com/customsearch/v1?key=AIzaSyDudd94Drzk1RJKt1fDmbTuw1QCxYSkj9A&cx=013819178164194751105:xof1sikmobe&q=';
  static String api2 = '&searchType=image&start=1&num=1';

  static Future getData(String search) async {
    
    /*For Real Usage use :*/
    String urlResponse;
    var response = await http.read(Uri.encodeFull(api1 + search + api2));
    Map<String, dynamic> data = jsonDecode(response);
    for (var item in data['items']) {
      urlResponse = item['link'];
    }
    print(urlResponse);
     return urlResponse; 

    /*For Testing Purposes use: 
    String testUrl = 'https://images.ctfassets.net/lcr8qbvxj7mh/5t66tGVtTcggwHV6jcjDiI/09d9220f725f399314743212ed0bdf83/CUT-SE_RBED_250_Single-Unit_close_ambien.png?w=770&q=100&fit=pad&fm=png';
    return testUrl; */
  }
}
