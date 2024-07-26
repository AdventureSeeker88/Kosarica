

import 'dart:convert';


import 'package:http/http.dart' as http;

class Appdetails {


  //..................................App details Repositry.........................................................


  Future fetchingAPPDETALS() async {
    try {
      final response = await http.get(Uri.parse("https://kosarica.smart-solutions.hr/api/kosaricaFlutter.php"),
        headers: {
          'Accept': '*/*',
          "Accept-Encoding": "gzip, deflate, br",
          "Connection": "keep-alive"

        },
      );
      print('resposeCode  ${response.statusCode}');
      print('body  ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return jsonData;
      } else {
        print('error2 $response');
        throw Exception('Failed to ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetching models');
    }
  }









}