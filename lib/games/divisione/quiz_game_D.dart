import 'dart:math';
import 'package:app_tabelline/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int num1 = 0;
  int num2 = 1; // Inizializza a 1 per evitare divisioni per zero
  int correctAnswer = 0;
  List<int> answers = [];
  List<Map<String, dynamic>> history = [];

  bool showFeedback = false; // Per mostrare la bandiera o la X
  bool isAnswerCorrect =
      false; // Per tenere traccia della correttezza della risposta
  double feedbackPosition =
      -100; // Posizione verticale della bandiera o della X

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();

    // Genera num1 e num2 in modo che num1 sia divisibile per num2
    num2 = random.nextInt(10) + 1; // num2 non può essere 0
    num1 = num2 *
        (random.nextInt(11)); // Garantire che num1 sia divisibile per num2
    correctAnswer = num1 ~/
        num2; // Usa la divisione intera per ottenere il risultato corretto

    // Genera risposte sbagliate vicine al risultato corretto
    Set<int> answerSet = {correctAnswer};
    while (answerSet.length < 4) {
      int wrongAnswer = correctAnswer +
          random.nextInt(5) -
          2; // Risposte sbagliate vicine (±2)
      if (wrongAnswer != correctAnswer && wrongAnswer >= 0) {
        answerSet.add(wrongAnswer);
      }
    }

    answers = answerSet.toList();
    answers.shuffle(); // Mischia le risposte

    setState(() {});
  }

  void checkAnswer(int selectedAnswer) {
    isAnswerCorrect = selectedAnswer == correctAnswer;
    showFeedback = true;

    // Aggiungi l'operazione alla lista
    history.add({
      'operation': '$num1 ÷ $num2',
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isAnswerCorrect,
    });

    // Limita la dimensione della storia
    if (history.length > 10) {
      history.removeAt(0);
    }

    // Animazione e generazione di nuove domande
    feedbackPosition = 0; // Reset della posizione
    setState(() {});

    Future.delayed(const Duration(seconds: 1), () {
      generateNewQuestion();
      showFeedback = false; // Nascondi il feedback
      feedbackPosition = -100; // Reset della posizione
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Quiz delle Tabelline'),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$num1 ÷ $num2 = ?',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 30),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.all(10),
                  childAspectRatio: 2.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: answers.map((answer) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        backgroundColor: Colors.blue[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        fixedSize: const Size(150, 70),
                      ),
                      onPressed:
                          showFeedback ? null : () => checkAnswer(answer),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$answer',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(history: history),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Risultati Quiz',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Bandiera verde o X rossa
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: feedbackPosition,
              left: 0,
              right: 0,
              child: showFeedback
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Icon(
                          isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                          size: 100,
                          color: isAnswerCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

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
