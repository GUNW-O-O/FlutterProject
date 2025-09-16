import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../widgets/flippable_card.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<Flashcard> _flashcards = [
    Flashcard(word: 'Apple', definition: '사과'),
    Flashcard(word: 'Banana', definition: '바나나'),
    Flashcard(word: 'Cherry', definition: '체리'),
    Flashcard(word: 'Grape', definition: '포도'),
    Flashcard(word: 'Orange', definition: '오렌지'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          return Center(
            child: FlippableCard(flashcard: _flashcards[index]),
          );
        },
      ),
    );
  }
}