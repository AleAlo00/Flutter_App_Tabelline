import 'package:flutter/material.dart';

class FeedbackAnimation extends StatefulWidget {
  final bool? userAnswer;
  final double feedbackPosition;

  const FeedbackAnimation({
    Key? key,
    required this.userAnswer,
    required this.feedbackPosition,
  }) : super(key: key);

  @override
  _FeedbackAnimationState createState() => _FeedbackAnimationState();
}

class _FeedbackAnimationState extends State<FeedbackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Avvia l'animazione quando l'utente risponde
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: widget.feedbackPosition,
      left: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.userAnswer! ? Colors.green[200] : Colors.red[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                widget.userAnswer! ? Icons.check_circle : Icons.cancel,
                size: 100,
                color: widget.userAnswer! ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
