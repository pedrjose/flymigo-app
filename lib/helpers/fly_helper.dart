import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>?> generateAirportsArray() async {
  const String baseUrl = 'https://buscamilhas.mock.gralmeidan.dev/aeroportos?q=';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<String> iataCodes = responseData
          .map((airport) => airport['Iata'] as String?)
          .where((iata) => iata != null)
          .cast<String>()
          .toList();

      return iataCodes;
    } else {
      print('Search airports error: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Req error: $e');
    return null;
  }
}


List<String> generateAirportCombinations() {
  List<String> combinations = [];
  for (int i = 65; i <= 83; i++) { 
    for (int j = 65; j <= 90; j++) { 
      for (int k = 65; k <= 90; k++) {
        String combination = String.fromCharCode(i) +
                             String.fromCharCode(j) +
                             String.fromCharCode(k);
        combinations.add(combination);
        if (combination == "SAO") return combinations;
      }
    }
  }
  
  return combinations;
}

String formatDate(String date) {
  List<String> parts = date.split('-');
  if (parts.length == 3) {
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
  return date;
}

