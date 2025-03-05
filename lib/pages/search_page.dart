import 'package:flutter/material.dart';
import '../services/search_service.dart';
import "../helpers/search_helper.dart";

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? travel;
  String? errorMessage;
  double? totalTax;

  Future<void> _searchTravel() async {
    setState(() {
      travel = null;
      errorMessage = null;
      totalTax = null;
    });

    try {
      final response = await fetchFirstItem(_idController.text);
      setState(() {
        travel = response;

       
        int numAdults = response!['QuantidadeAdultos'] ?? 1; 
        int numChildren = response['QuantidadeCriancas'] ?? 0; 
        int numBabies = response['QuantidadeBebes'] ?? 0;

        totalTax = calculateTax(response['Valor'], numAdults, numChildren, numBabies);
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching travel details: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Viagem')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              shadowColor: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: 'Viagem ID',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _searchTravel,
                        child: Text('Buscar Viagem'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            if (errorMessage != null) ...[
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
            if (travel != null) ...[
              Text("Companhia: ${travel!['Companhia']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Tipo: ${travel!['Sentido']}", style: TextStyle(fontSize: 16)),
              Text("Origem: ${travel!['Origem']}", style: TextStyle(fontSize: 16)),
              Text("Destino: ${travel!['Destino']}", style: TextStyle(fontSize: 16)),
              Text("Embarcação: ${travel!['Embarque']}", style: TextStyle(fontSize: 16)),
              Text("Desembarcação: ${travel!['Desembarque']}", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10.0),
              // Display the calculated total tax
              Text(
                "Taxa Total: \$ ${totalTax?.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
