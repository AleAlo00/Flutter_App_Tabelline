import 'dart:math';
import 'package:app_tabelline/widgets/app_bar.dart';
import 'package:app_tabelline/widgets/custom_button.dart';
import 'package:app_tabelline/widgets/results_page.dart';
import 'package:flutter/material.dart';
import 'package:app_tabelline/widgets/feedback_animation.dart';
// Assicurati di importare la ResultsPage

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
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
    num2 = random.nextInt(10) + 1;
    num1 = random.nextInt(11);
    correctAnswer = num1 * num2;

    Set<int> answerSet = {correctAnswer};

    while (answerSet.length < 4) {
      int wrongAnswer = correctAnswer + random.nextInt(5) - 2;
      if (wrongAnswer != correctAnswer && wrongAnswer >= 0) {
        answerSet.add(wrongAnswer);
      }
    }

    answers = answerSet.toList()..shuffle();
    setState(() {});
  }

  void checkAnswer(int selectedAnswer) {
    isAnswerCorrect = selectedAnswer == correctAnswer;
    showFeedback = true;

    history.add({
      'operation': '$num1 x $num2',
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isAnswerCorrect,
    });

    if (history.length > 10) history.removeAt(0);

    feedbackPosition = 0;
    setState(() {});

    Future.delayed(const Duration(seconds: 1), () {
      generateNewQuestion();
      showFeedback = false;
      feedbackPosition = -100;
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
                  '$num1 x $num2 = ?',
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
                    return CustomButton(
                      text: '$answer',
                      onPressed: showFeedback ? () {} : () => checkAnswer(answer),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Risultati Quiz',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(history: history),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ],
            ),
            if (showFeedback)
              FeedbackAnimation(
                userAnswer: isAnswerCorrect,
                feedbackPosition: feedbackPosition,
              ),
          ],
        ),
      ),
    );
  }
}
