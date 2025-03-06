import 'dart:convert';
import 'package:http/http.dart' as http;

class TravelService {
  final String baseUrl;

  TravelService({required this.baseUrl});

  Future<Map<String, dynamic>?> fetchFirstItem(String id) async {
    final String url = "$baseUrl/busca/$id";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey("Voos")) {
          print("Tipo de 'Voos': ${data["Voos"].runtimeType}");
          print("Conteúdo de 'Voos': ${data["Voos"]}");

          if (data["Voos"] is List && data["Voos"].isNotEmpty) {
            var firstFly = data["Voos"][0];

            print("Tipo do primeiro item de 'Voos': ${firstFly.runtimeType}");
            print("Conteúdo do primeiro item de 'Voos': $firstFly");

            if (firstFly is Map<String, dynamic>) {
              return firstFly;
            } else {
              print("Erro: O primeiro item de 'Voos' não é um Map.");
            }
          } else {
            print("Erro: 'Voos' está vazio ou não é uma lista.");
          }
        } else {
          print("Erro: 'Voos' não encontrado no JSON.");
        }

        if (data.containsKey('items') && data['items'] is List<dynamic> && data['items'].isNotEmpty) {
          print("Primeiro item de 'items': ${data['items'][0]}");
          return data['items'][0];
        } else {
          print("Nenhum item encontrado.");
        }
      } else {
        print("Erro na requisição: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao buscar viagem: $e");
      throw Exception("Erro ao buscar viagem: $e");
    }

    return null;
  }
}
