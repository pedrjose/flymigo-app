import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> createFlyService(Map<String, dynamic> data) async {
  const String url = 'https://buscamilhas.mock.gralmeidan.dev/busca/criar';
  
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['Busca'];
    } else {
      print('Error creating search: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Request error: $e');
    return null;
  }
}