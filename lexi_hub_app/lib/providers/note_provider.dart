import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import 'auth_provider.dart';

enum NoteStatus { initial, loading, loaded, error }

class NoteProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();
  final AuthProvider _authProvider;

  NoteProvider(this._authProvider);

  // State for the list of notes
  List<Note> _notes = [];
  NoteStatus _listStatus = NoteStatus.initial;
  String? _listErrorMessage;

  List<Note> get notes => _notes;
  NoteStatus get listStatus => _listStatus;
  String? get listErrorMessage => _listErrorMessage;

  // State for a single selected note
  Note? _selectedNote;
  NoteStatus _selectedNoteStatus = NoteStatus.initial;
  String? _selectedNoteErrorMessage;

  Note? get selectedNote => _selectedNote;
  NoteStatus get selectedNoteStatus => _selectedNoteStatus;
  String? get selectedNoteErrorMessage => _selectedNoteErrorMessage;

  Future<void> fetchNotes() async {
    if (_authProvider.token == null) {
      _listStatus = NoteStatus.error;
      _listErrorMessage = "로그인이 필요합니다.";
      notifyListeners();
      return;
    }

    _listStatus = NoteStatus.loading;
    notifyListeners();

    try {
      _notes = await _noteService.getNotes(_authProvider.token!);
      _listStatus = NoteStatus.loaded;
    } catch (e) {
      _listStatus = NoteStatus.error;
      _listErrorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNoteById(String noteId) async {
    if (_authProvider.token == null) {
      _selectedNoteStatus = NoteStatus.error;
      _selectedNoteErrorMessage = "로그인이 필요합니다.";
      notifyListeners();
      return;
    }

    _selectedNoteStatus = NoteStatus.loading;
    notifyListeners();

    try {
      _selectedNote = await _noteService.getNoteById(_authProvider.token!, noteId);
      _selectedNoteStatus = NoteStatus.loaded;
    } catch (e) {
      _selectedNoteStatus = NoteStatus.error;
      _selectedNoteErrorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void clearSelectedNote() {
    _selectedNote = null;
    _selectedNoteStatus = NoteStatus.initial;
    _selectedNoteErrorMessage = null;
  }
}