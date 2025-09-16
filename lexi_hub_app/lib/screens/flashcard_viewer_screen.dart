import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/flippable_card.dart';

class FlashcardViewerScreen extends StatefulWidget {
  final String title;
  final String noteId;

  const FlashcardViewerScreen({Key? key, required this.title, required this.noteId}) : super(key: key);

  @override
  _FlashcardViewerScreenState createState() => _FlashcardViewerScreenState();
}

class _FlashcardViewerScreenState extends State<FlashcardViewerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).fetchNoteById(widget.noteId);
    });
  }

  @override
  void dispose() {
    // Clear the selected note when the screen is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<NoteProvider>(context, listen: false).clearSelectedNote();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          switch (noteProvider.selectedNoteStatus) {
            case NoteStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NoteStatus.error:
              return Center(
                child: Text(noteProvider.selectedNoteErrorMessage ?? '카드 정보를 불러오는 데 실패했습니다.'),
              );
            case NoteStatus.loaded:
              final flashcards = noteProvider.selectedNote?.flashcards;
              if (flashcards == null || flashcards.isEmpty) {
                return const Center(
                  child: Text('단어장에 카드가 없습니다.', style: TextStyle(fontSize: 18)),
                );
              }
              return PageView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: FlippableCard(flashcard: flashcards[index]),
                  );
                },
              );
            case NoteStatus.initial:
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}