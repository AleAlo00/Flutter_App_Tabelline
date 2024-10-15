import 'package:flutter/material.dart';

class FeedbackAnimation extends StatelessWidget {
  final bool? userAnswer;
  final double feedbackPosition;

  const FeedbackAnimation({
    Key? key,
    required this.userAnswer,
    required this.feedbackPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: feedbackPosition,
      left: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Icon(
            userAnswer! ? Icons.check_circle : Icons.cancel,
            size: 100,
            color: userAnswer! ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
