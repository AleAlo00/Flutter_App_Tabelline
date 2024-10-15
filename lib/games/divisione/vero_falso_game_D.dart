import 'package:flutter/material.dart';

class VeroFalsoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vero/Falso Game'),
      ),
      body: Center(
        child: Text(
          'Benvenuto al gioco Vero o Falso!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
