import 'package:app_tabelline/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../moltiplicazione/quiz_game_P.dart';
import '../moltiplicazione/vero_falso_game_P.dart';

class MoltiplicazioniGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Moltiplicazioni'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seleziona un gioco :',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizGame()),
                );
              },
              child: Text('Quiz'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrueFalseGame()),
                );
              },
              child: Text('Vero/Falso'),
            ),
          ],
        ),
      ),
    );
  }
}
