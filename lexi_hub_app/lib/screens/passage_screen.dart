
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';
import 'passage_detail_screen.dart';

class PassageScreen extends StatefulWidget {
  const PassageScreen({Key? key}) : super(key: key);

  @override
  _PassageScreenState createState() => _PassageScreenState();
}

class _PassageScreenState extends State<PassageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isLoggedIn) {
            return const Center(
              child: Text('장문 목록을 보려면 로그인이 필요합니다.', style: TextStyle(fontSize: 18)),
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
                  final longformNotes = noteProvider.notes.where((note) => note.type == 'longform').toList();
                  if (longformNotes.isEmpty) {
                    return const Center(
                      child: Text('저장된 장문이 없습니다. 추가해주세요!', style: TextStyle(fontSize: 18)),
                    );
                  }
                  return _buildPassageList(context, longformNotes);
                case NoteStatus.initial:
                default:
                  return const Center(child: Text('장문 목록을 불러오는 중입니다...'));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildPassageList(BuildContext context, List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            // Subtitle removed as content is not available in the list view
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassageDetailScreen(
                    title: note.title,
                    noteId: note.id, // Pass noteId instead of content
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
