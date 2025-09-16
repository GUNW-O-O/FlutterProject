
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';
import 'flashcard_viewer_screen.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotesIfLoggedIn();
    });
  }

  void _fetchNotesIfLoggedIn() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      Provider.of<NoteProvider>(context, listen: false).fetchNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoggedIn && Provider.of<NoteProvider>(context, listen: false).listStatus == NoteStatus.initial) {
            Provider.of<NoteProvider>(context, listen: false).fetchNotes();
          }

          if (!authProvider.isLoggedIn) {
            return const Center(
              child: Text('단어장을 보려면 로그인이 필요합니다.', style: TextStyle(fontSize: 18)),
            );
          }

          return Consumer<NoteProvider>(
            builder: (context, noteProvider, child) {
              switch (noteProvider.listStatus) {
                case NoteStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case NoteStatus.error:
                  return Center(
                    child: Text(noteProvider.listErrorMessage ?? '알 수 없는 에러가 발생했습니다.'),
                  );
                case NoteStatus.loaded:
                  if (noteProvider.notes.isEmpty) {
                    return const Center(
                      child: Text('저장된 단어장이 없습니다. 추가해주세요!', style: TextStyle(fontSize: 18)),
                    );
                  }
                  return _buildNoteDecksList(context, noteProvider.notes);
                case NoteStatus.initial:
                default:
                  return const Center(child: Text('단어장을 불러오는 중입니다...'));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildNoteDecksList(BuildContext context, List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        if (note.type == 'flashcard') {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              // Subtitle removed as flashcards list is not available here
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate with noteId and title, not the flashcards list
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardViewerScreen(
                      title: note.title,
                      noteId: note.id, // Pass the ID
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
