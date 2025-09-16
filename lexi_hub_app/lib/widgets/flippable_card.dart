import 'dart:math';
import 'package:flutter/material.dart';
import '../models/note_model.dart'; // Updated import

class FlippableCard extends StatefulWidget {
  final FlashcardItem flashcard; // Updated to use FlashcardItem

  const FlippableCard({Key? key, required this.flashcard}) : super(key: key);

  @override
  _FlippableCardState createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }
  
  // Reset the card to the front when the widget is updated with a new card
  @override
  void didUpdateWidget(covariant FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcard.word != oldWidget.flashcard.word) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_controller.isCompleted || _controller.isAnimating) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final angle = _animation.value * pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);

    return GestureDetector(
      onTap: _handleTap,
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child: _animation.value < 0.5
            ? _buildCardFace(widget.flashcard.word)
            : Transform(
                transform: Matrix4.identity()..rotateY(pi),
                alignment: Alignment.center,
                child: _buildCardFace(widget.flashcard.meaning, isFront: false), // Updated to use .meaning
              ),
      ),
    );
  }

  Widget _buildCardFace(String text, {bool isFront = true}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        height: 400,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}