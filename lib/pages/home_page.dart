import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Flymigo',
            style: TextStyle(
              fontFamily: 'Hind', 
              fontSize: 24,
              fontWeight: FontWeight.bold, 
              color: Colors.white, 
              shadows: [
                Shadow(
                  color: Colors.black, 
                  offset: Offset(0, 2), 
                  blurRadius: 10, 
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.green, 
        elevation: 5,
      ),
      body: Center(
        child: Text('Conteúdo da página'),
      ),
    );
  }
}
