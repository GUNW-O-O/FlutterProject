
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note_model.dart';

class NoteService {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<List<Note>> getNotes(String token) async {
    final url = Uri.parse('$_baseUrl/notes');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8 decoding for Korean characters
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((item) => Note.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching notes: $e');
    }
  }

  Future<Note> getNoteById(String token, String noteId) async {
    final url = Uri.parse('$_baseUrl/notes/$noteId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return Note.fromJson(data);
      } else {
        throw Exception('Failed to load note details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching note details: $e');
    }
  }
}
