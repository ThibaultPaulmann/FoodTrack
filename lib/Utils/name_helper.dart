import 'package:http/http.dart' as http;
import 'dart:convert';

class NameHelper {
  static String api1 =
      'https://api.ean-search.org/api?token=5731c2fea322d632f0923ba64a9310&op=barcode-lookup&format=json&ean=';

  static Future getName(String search) async {
    /* For real Usage: */
    var response = await http.read(Uri.encodeFull(api1 + search));
    List<dynamic> data = jsonDecode(response);
    var result = data[0]['name'];
    print(result);
    return result;
    
    /*For Test Usage
    String testName = 'Alubia Blanca';
    return testName; */
  }
}
