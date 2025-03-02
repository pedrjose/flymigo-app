import 'package:flutter/material.dart';
import 'fly_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 80.0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
    title: Image.asset(
      'logo.png',  
      height: 50,         
      fit: BoxFit.contain, 
    ),
  centerTitle: true,
  elevation: 8.0,
),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'O que você quer fazer?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text('Criar Viagem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlyPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.travel_explore),
              title: Text('Buscar Viagem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        'slogan.png',
        height: 100,
        fit: BoxFit.contain,
      ),
      SizedBox(height: 10), 
      Text(
        'Seja um voador e desfrute de nossas viagens!',
        textAlign: TextAlign.center, 
      ),
    ],
  ),
)

    );
  }
}
