import 'package:flutter/material.dart';
import 'package:app_tabelline/widgets/app_bar.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const ResultsPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Risultati Quiz'),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 2,
              child: ListTile(
                leading: item['isCorrect']
                    ? const Icon(Icons.check_circle,
                        color: Colors.green, size: 30)
                    : const Icon(Icons.cancel, color: Colors.red, size: 30),
                title: Text(
                  item['operation'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                subtitle: Text(
                  'Risultato scelto: ${item['selectedAnswer']}${item['isCorrect'] ? '' : '\nRisultato corretto: ${item['correctAnswer']}'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[600],
                  ),
                ),
                trailing: item['isCorrect']
                    ? const Text('Corretto',
                        style: TextStyle(color: Colors.green, fontSize: 18))
                    : const Text('Sbagliato',
                        style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
            );
          },
        ),
      ),
    );
  }
}
