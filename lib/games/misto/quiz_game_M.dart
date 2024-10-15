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
  int num2 = 0;
  int correctAnswer = 0;
  String currentOperation =
      ''; // Variabile per tenere traccia dell'operazione corrente
  List<int> answers = [];
  List<Map<String, dynamic>> history = [];

  bool showFeedback = false;
  bool isAnswerCorrect = false;
  double feedbackPosition = -100;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();
    bool isMultiplication =
        random.nextBool(); // Scegli casualmente tra moltiplicazione e divisione

    num1 = random.nextInt(11) + 1; // Evitare lo zero nella divisione
    num2 = random.nextInt(11) + 1;

    if (isMultiplication) {
      currentOperation = 'x';
      correctAnswer = num1 * num2;
    } else {
      currentOperation = '÷';
      correctAnswer = num1; // Assumiamo che il risultato sia num1
      num1 = num1 * num2; // Generiamo num1 come prodotto per evitare decimali
    }

    // Set per memorizzare le risposte uniche
    Set<int> answerSet = {correctAnswer};

    // Generazione delle risposte sbagliate uniche
    while (answerSet.length < 4) {
      int wrongAnswer =
          correctAnswer + random.nextInt(5) - 2; // Risposte sbagliate vicine

      // Controlla che la risposta sia unica e positiva
      if (wrongAnswer != correctAnswer && wrongAnswer > 0) {
        answerSet.add(wrongAnswer);
      }
    }

    // Trasformare il set in una lista
    answers = answerSet.toList();

    // Mischia le risposte per una migliore esperienza utente
    answers.shuffle();

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
      appBar: CustomAppBar(title: 'Risultati Quiz'),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$num1 $currentOperation $num2 = ?',
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
                        color: Colors.white),
                  ),
                ),
              ],
            ),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Risultati Quiz',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
      ),
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
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
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
