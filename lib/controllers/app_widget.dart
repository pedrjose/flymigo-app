import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import '../../pages/ticket_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flymigo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    if (settings.name == '/voo') {
      final args = settings.arguments as Map<String, dynamic>?;
      if (args?.containsKey('travelId') ?? false) {
        return MaterialPageRoute(
          builder: (context) => TicketPage(travelId: args!['travelId']),
        );
      }
    }
    return MaterialPageRoute(builder: (context) => HomePage());
  }
}