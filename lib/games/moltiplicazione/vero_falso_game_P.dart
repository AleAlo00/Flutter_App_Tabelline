import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_tabelline/widgets/app_bar.dart';
import 'package:app_tabelline/widgets/custom_button.dart';
import 'package:app_tabelline/widgets/feedback_animation.dart';


class TrueFalseGame extends StatefulWidget {
  const TrueFalseGame({super.key});

  @override
  _TrueFalseGameState createState() => _TrueFalseGameState();
}

class _TrueFalseGameState extends State<TrueFalseGame> {
  final Random random = Random();
  int currentMultiplier = 0;
  int currentMultiplicand = 0;
  int correctResult = 0;
  bool? userAnswer;
  bool showFeedback = false;
  double feedbackPosition = -100;
  String displayedResult = "";
  bool isCorrectAnswer = false;

  // Storia delle risposte
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    currentMultiplier = random.nextInt(10) + 1;
    currentMultiplicand = random.nextInt(10) + 1;
    correctResult = currentMultiplier * currentMultiplicand;

    isCorrectAnswer = random.nextBool();

    if (isCorrectAnswer) {
      displayedResult = correctResult.toString();
    } else {
      displayedResult = (correctResult +
              (random.nextBool() ? 1 : -1) * (random.nextInt(2) + 1))
          .toString();
    }
  }

  void checkAnswer(bool selectedAnswer) {
    userAnswer = selectedAnswer == isCorrectAnswer;
    showFeedback = true;

    history.add({
      'statement':
          '$currentMultiplier x $currentMultiplicand = $displayedResult',
      'selectedAnswer': selectedAnswer,
      'isCorrect': userAnswer,
    });

    feedbackPosition = 0;
    setState(() {});

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        generateNewQuestion();
        userAnswer = null;
        showFeedback = false;
        feedbackPosition = -100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Vero/Falso'),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$currentMultiplier x $currentMultiplicand = $displayedResult',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onPressed: showFeedback ? () {} : () => checkAnswer(true),
                    text: 'Vero',
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                  ),
                  CustomButton(
                    onPressed: showFeedback ? () {} : () => checkAnswer(false),
                    text: 'Falso',
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: showFeedback
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsPage(history: history),
                          ),
                        );
                      },
                text: 'Risultati',
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              ),
            ],
          ),
          if (showFeedback)
            FeedbackAnimation(
              userAnswer: userAnswer,
              feedbackPosition: feedbackPosition,
            ),
        ],
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
      appBar: const CustomAppBar(title: 'Risultati Quiz'),
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
                  item['statement'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
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
