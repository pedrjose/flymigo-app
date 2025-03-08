import 'package:flutter/material.dart';
import '../helpers/search_helper.dart';
import '../services/search_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _babiesController = TextEditingController();

  Map<String, dynamic>? travel;
  String? errorMessage;
  double? totalTax;

  final TravelService _travelService =
      TravelService(baseUrl: "https://buscamilhas.mock.gralmeidan.dev");

  Future<void> _searchTravel() async {
    setState(() {
      travel = null;
      errorMessage = null;
      totalTax = null;
    });

    try {
      final response = await _travelService.fetchFirstItem(_idController.text);
      if (response != null) {
        _updateTravelDetails(response);
      } else {
        _setErrorMessage("Erro: resposta da viagem é nula.");
      }
    } catch (e) {
      _setErrorMessage("Erro ao buscar detalhes da viagem: ${e.toString()}");
    }
  }

  void _updateTravelDetails(Map<String, dynamic> response) {
    setState(() {
      travel = response;
      totalTax = calculateTax(
        response['Valor'],
        int.tryParse(_adultsController.text) ?? 1,
        int.tryParse(_childrenController.text) ?? 0,
        int.tryParse(_babiesController.text) ?? 0,
      );
    });
  }

  void _setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSearchCard(),
            const SizedBox(height: 20.0),
            if (errorMessage != null) _buildErrorMessage(),
            if (travel != null) _buildTravelDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      shadowColor: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_idController, 'Viagem ID'),
            const SizedBox(height: 10.0),
            _buildTextField(_adultsController, 'Número de Adultos', true),
            const SizedBox(height: 10.0),
            _buildTextField(_childrenController, 'Número de Crianças', true),
            const SizedBox(height: 10.0),
            _buildTextField(_babiesController, 'Número de Bebês', true),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _searchTravel,
              child: const Text('Buscar Viagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [bool isNumeric = false]) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      errorMessage!,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTravelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailText("Companhia", travel!['Companhia']),
        _buildDetailText("Tipo", travel!['Sentido']),
        _buildDetailText("Origem", travel!['Origem']),
        _buildDetailText("Destino", travel!['Destino']),
        _buildDetailText("Embarcação", travel!['Embarque']),
        _buildDetailText("Desembarcação", travel!['Desembarque']),
        const SizedBox(height: 10.0),
        Text(
          "Taxa Total: \$ ${totalTax?.toStringAsFixed(2) ?? '0.00'}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Text(
      "$label: $value",
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}
