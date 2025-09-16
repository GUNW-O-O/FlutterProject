import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class PassageDetailScreen extends StatefulWidget {
  final String title;
  final String noteId;

  const PassageDetailScreen({Key? key, required this.title, required this.noteId}) : super(key: key);

  @override
  _PassageDetailScreenState createState() => _PassageDetailScreenState();
}

class _PassageDetailScreenState extends State<PassageDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).fetchNoteById(widget.noteId);
    });
  }

  @override
  void dispose() {
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
                child: Text(noteProvider.selectedNoteErrorMessage ?? '내용을 불러오는 데 실패했습니다.'),
              );
            case NoteStatus.loaded:
              final content = noteProvider.selectedNote?.content;
              if (content == null || content.isEmpty) {
                return const Center(
                  child: Text('내용이 없습니다.', style: TextStyle(fontSize: 18)),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
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