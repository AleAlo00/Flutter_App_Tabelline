import "package:app_tabelline/widgets/app_bar.dart";
import 'package:flutter/material.dart';
import "../misto/quiz_game_M.dart";
import "../misto/vero_falso_game_M.dart";

class MistoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Misto'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seleziona un gioco di quiz:',
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
                  MaterialPageRoute(builder: (context) => VeroFalsoGame()),
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
