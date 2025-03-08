import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import '../../pages/ticket_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flymigo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/voo') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('travelId')) {
            return MaterialPageRoute(
              builder: (context) => TicketPage(travelId: args['travelId']),
            );
          }
        }

        return MaterialPageRoute(builder: (context) => HomePage());
      },
    );
  }
}
