import '../helpers/fly_helper.dart';
import 'package:flutter/material.dart';
import '../services/fly_service.dart';
import 'ticket_page.dart';

class FlyPage extends StatefulWidget {
  @override
  _FlyPageState createState() => _FlyPageState();
}

class _FlyPageState extends State<FlyPage> {
  final List<String> airlines = [
    'AMERICAN AIRLINES', 'GOL', 'IBERIA', 'INTERLINE', 'LATAM', 'AZUL', 'TAP'
  ];
  
  final TextEditingController _flyAirline = TextEditingController();
  final TextEditingController _originAirport = TextEditingController();
  final TextEditingController _destinationAirport = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  DateTime? _departureDate;
  DateTime? _returnDate;
  List<String> airports = [];
  String? _tripType = 'Ida';
  String? _responseMessage;
  
  @override
  void initState() {
    super.initState();
    _fetchAirports();
  }

  Future<void> _fetchAirports() async {
    final result = await generateAirportsArray();
    setState(() => airports = result ?? []);
  }

  void _selectDate(BuildContext context, bool isReturnDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isReturnDate) {
          _returnDate = pickedDate;
          _returnDateController.text = _formatDate(_returnDate);
        } else {
          _departureDate = pickedDate;
          _departureDateController.text = _formatDate(_departureDate);
        }
      });
    }
  }

  String _formatDate(DateTime? date) => date != null ? '${date.toLocal()}'.split(' ')[0] : '';

  Future<void> _createFlight() async {
    if (_formKey.currentState?.validate() ?? false) {
      final requestData = {
        'Companhias': [_flyAirline.text],
        'DataIda': formatDate(_departureDateController.text),
        'DataVolta': _returnDateController.text.isEmpty ? null : formatDate(_returnDateController.text),
        'Origem': _originAirport.text,
        'Destino': _destinationAirport.text,
        'Tipo': _tripType,
      };

      final response = await FlyService().createFly(requestData);
      setState(() => _responseMessage = response != null ? 'Viagem criada com sucesso: $response' : 'Erro ao criar viagem.');
      
      if (response != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TicketPage(travelId: response)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildDropdown(),
              const SizedBox(height: 10.0),
              _buildAutocompleteField(_flyAirline, 'Selecione uma companhia aérea', airlines),
              const SizedBox(height: 10.0),
              _buildAutocompleteField(_originAirport, 'Digite ou selecione o aeroporto de origem', airports),
              const SizedBox(height: 10.0),
              _buildAutocompleteField(_destinationAirport, 'Digite ou selecione o aeroporto de destino', airports),
              const SizedBox(height: 10.0),
              _buildDateField('Data de Ida', _departureDateController, () => _selectDate(context, false)),
              const SizedBox(height: 20.0),
              if (_tripType == 'IdaVolta') _buildDateField('Data de Volta', _returnDateController, () => _selectDate(context, true)),
              const SizedBox(height: 20.0),
              _buildSubmitButton(),
              if (_responseMessage != null) _buildResponseMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _tripType,
      decoration: const InputDecoration(labelText: 'Tipo de Viagem', border: OutlineInputBorder()),
      items: ['Ida', 'IdaVolta'].map((trip) => DropdownMenuItem(value: trip, child: Text(trip))).toList(),
      onChanged: (value) => setState(() {
        _tripType = value;
        if (_tripType == 'Ida') _returnDateController.clear();
      }),
      validator: (value) => value?.isEmpty ?? true ? 'Por favor, selecione o tipo de viagem' : null,
    );
  }

  Widget _buildAutocompleteField(TextEditingController controller, String hint, List<String> options) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) => options.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase())),
      onSelected: (selection) => controller.text = selection,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(labelText: hint, border: const OutlineInputBorder()),
        validator: (value) => value?.isEmpty ?? true ? 'Por favor, preencha este campo' : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: onTap),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Por favor, selecione a $label' : null,
      readOnly: true,
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _createFlight,
        child: const Text('Criar Viagem'),
      ),
    );
  }

  Widget _buildResponseMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            _responseMessage!,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
