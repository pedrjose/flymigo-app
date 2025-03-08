import 'package:flutter/material.dart';
import 'fly_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      toolbarHeight: 80.0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Image.asset(
        'logo.png',
        height: 50,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      elevation: 8.0,
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.flight_takeoff,
            text: 'Criar Viagem',
            onTap: () => _navigateTo(context, FlyPage()),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.travel_explore,
            text: 'Buscar Viagem',
            onTap: () => _navigateTo(context, SearchPage()),
          ),
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader() {
    return const DrawerHeader(
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
    );
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'slogan.png',
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            'Seja um voador e desfrute de nossas viagens!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
