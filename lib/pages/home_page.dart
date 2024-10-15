import 'package:flutter/material.dart';
// Importa il file del quiz
// Importa il file del vero/falso
import '../games/moltiplicazione/moltiplicazioni.dart';
import '../games/divisione/divisioni.dart';
import '../games/misto/misto.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seleziona una modalità:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoltiplicazioniGame()),
                );
              },
              child: Text('Moltiplicazioni'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DivisioniGame()),
                );
              },
              child: Text('Divisioni'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MistoGame()),
                );
              },
              child: Text('Misto'),
            ),
          ],
        ),
      ),
    );
  }
}
