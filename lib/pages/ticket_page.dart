import 'package:flutter/material.dart';
import "../services/search_service.dart";
import "../helpers/search_helper.dart";

class TicketPage extends StatefulWidget {
  final String travelId;

  const TicketPage({required this.travelId, Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  Map<String, dynamic>? travel;
  String? errorMessage;
  double? totalTax;

  final TravelService _travelService = TravelService(baseUrl: "https://buscamilhas.mock.gralmeidan.dev");

  final TextEditingController _adultsController = TextEditingController(text: "1");
  final TextEditingController _childrenController = TextEditingController(text: "0");
  final TextEditingController _babiesController = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    _searchTravel();
  }

  Future<void> _searchTravel() async {
    setState(() {
      travel = null;
      errorMessage = null;
      totalTax = null;
    });

    try {
      final response = await _travelService.fetchFirstItem(widget.travelId);
      if (response != null) {
        setState(() {
          travel = response;
          _resetPassengerCounts();
          _calculateTotalTax();
        });
      } else {
        setState(() => errorMessage = "Erro: resposta da viagem é nula.");
      }
    } catch (e) {
      setState(() => errorMessage = "Erro ao buscar detalhes da viagem: ${e.toString()}");
    }
  }

  void _resetPassengerCounts() {
    _adultsController.text = '1';
    _childrenController.text = '0';
    _babiesController.text = '0';
  }

  void _calculateTotalTax() {
    if (travel == null) return;

    int numAdults = int.tryParse(_adultsController.text) ?? 1;
    int numChildren = int.tryParse(_childrenController.text) ?? 0;

    var valor = travel!['Valor']?[0] ?? {};

    double valorAdulto = valor['Adulto'] ?? 0;
    double valorCrianca = valor['Crianca'] ?? 0;
    double taxaEmbarque = valor['TaxaEmbarque'] ?? 0;

    setState(() {
      totalTax = (valorAdulto * numAdults) + (valorCrianca * numChildren) + (taxaEmbarque * (numAdults + numChildren));
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (value) => _calculateTotalTax(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Passagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: travel == null
            ? Center(
                child: errorMessage != null
                    ? Text(errorMessage!, style: const TextStyle(color: Colors.red))
                    : const CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Companhia: ${travel!['Companhia']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Origem: ${travel!['Origem']}", style: const TextStyle(fontSize: 16)),
                  Text("Destino: ${travel!['Destino']}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10.0),
                  const Divider(),
                  _buildTextField('Número de Adultos', _adultsController),
                  _buildTextField('Número de Crianças', _childrenController),
                  _buildTextField('Número de Bebês', _babiesController),
                  const SizedBox(height: 10.0),
                  Text(
                    "Taxa Total: R\$ ${totalTax?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _searchTravel,
                      child: const Text('Recalcular Taxa'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
