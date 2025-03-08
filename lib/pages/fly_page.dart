import '../helpers/fly_helper.dart';
import 'package:flutter/material.dart';
import '../services/fly_service.dart';  // Certifique-se de importar o serviço corretamente
import 'ticket_page.dart';  // Certifique-se de importar a página TicketPage

class FlyPage extends StatefulWidget {
  @override
  _FlyPageState createState() => _FlyPageState();
}

class _FlyPageState extends State<FlyPage> {
  List<String> airports = [];
  List<String> airlines = [
    'AMERICAN AIRLINES',
    'GOL',
    'IBERIA',
    'INTERLINE',
    'LATAM',
    'AZUL',
    'TAP'
  ];

  final TextEditingController _flyAirline = TextEditingController();
  final TextEditingController _originAirport = TextEditingController();
  final TextEditingController _destinationAirport = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _departureDate;
  DateTime? _returnDate;

  String? _tripType = 'Ida';
  String? _responseMessage;

  @override
  void initState() {
    super.initState();
    fetchAirports();
  }

  void fetchAirports() async {
    final result = await generateAirportsArray();
    setState(() {
      airports = result!;
    });
  }

  void _selectDate(BuildContext context, bool isReturnDate) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          if (isReturnDate) {
            _returnDate = pickedDate;
            _returnDateController.text = '${_returnDate!.toLocal()}'.split(' ')[0];
          } else {
            _departureDate = pickedDate;
            _departureDateController.text = '${_departureDate!.toLocal()}'.split(' ')[0];
          }
        });
      }
    });
  }

  Future<void> _createFlight() async {
    print(formatDate(_departureDateController.text));
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> requestData = {
        'Companhias': [_flyAirline.text],
        'DataIda': formatDate(_departureDateController.text),
        'DataVolta': _returnDateController.text.isEmpty ? null : formatDate(_returnDateController.text),
        'Origem': _originAirport.text,
        'Destino': _destinationAirport.text,
        'Tipo': _tripType,
      };

      // Instanciar o serviço FlyService e chamar o método createFly
      FlyService flyService = FlyService();
      String? response = await flyService.createFly(requestData);

      setState(() {
        _responseMessage = response != null
            ? 'Viagem criada com sucesso: ${response}'
            : 'Erro ao criar viagem.';
      });

      if (response != null) {
        // Navegar para a TicketPage passando o ID da viagem
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPage(travelId: response),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Viagem')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _tripType,
                decoration: InputDecoration(
                  labelText: 'Tipo de Viagem',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                items: ['Ida', 'IdaVolta']
                    .map((trip) => DropdownMenuItem<String>(value: trip, child: Text(trip)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tripType = value;
                    if (_tripType == 'Ida') {
                      _returnDate = null;
                      _returnDateController.clear();
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o tipo de viagem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return airlines.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _flyAirline.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Selecione uma companhia aérea',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma companhia aérea';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.0),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (airports == null) {
                    return const Iterable<String>.empty();
                  } else if (airports.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return airports.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _originAirport.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return airports == null
                      ? Text("Carregando...")
                      : airports.isEmpty
                          ? Text("")
                          : TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintText: 'Digite ou selecione o aeroporto de origem',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione um aeroporto de origem';
                                }
                                return null;
                              },
                            );
                },
              ),
              SizedBox(height: 10.0),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (airports == null) {
                    return const Iterable<String>.empty();
                  } else if (airports.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return airports.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _destinationAirport.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return airports == null
                      ? Text("Carregando...")
                      : airports.isEmpty
                          ? Text("")
                          : TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintText: 'Digite ou selecione o aeroporto de destino',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione um aeroporto de destino';
                                }
                                return null;
                              },
                            );
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _departureDateController,
                decoration: InputDecoration(
                  labelText: 'Data de Ida',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (_departureDate == null) {
                    return 'Por favor, selecione a data de ida';
                  }
                  return null;
                },
                readOnly: true,
              ),
              SizedBox(height: 10.0),
              if (_tripType == 'IdaVolta') ...[
                TextFormField(
                  controller: _returnDateController,
                  decoration: InputDecoration(
                    labelText: 'Data de Volta',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, true),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) {
                    if (_returnDate == null) {
                      return 'Por favor, selecione a data de volta';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
              ],
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _createFlight,
                  child: Text('Criar Viagem'),
                ),
              ),
              if (_responseMessage != null) ...[
                SizedBox(height: 20.0),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SelectableText(
                      _responseMessage!,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
