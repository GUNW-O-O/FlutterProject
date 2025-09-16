// Represents the items in the 'flashcards' array within a Note document
class FlashcardItem {
  final String word;
  final String meaning;

  FlashcardItem({required this.word, required this.meaning});

  factory FlashcardItem.fromJson(Map<String, dynamic> json) {
    return FlashcardItem(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }
}

// Represents the main Note document schema
class Note {
  final String id;
  final String title;
  final String type;
  final List<FlashcardItem> flashcards;
  final String? content;
  final String author;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.type,
    required this.flashcards,
    this.content,
    required this.author,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    List<FlashcardItem> parsedFlashcards = [];
    if (json['flashcards'] != null && json['flashcards'] is List) {
      // Explicitly cast to List<dynamic> to be safe
      List<dynamic> flashcardsData = json['flashcards'];
      parsedFlashcards = flashcardsData
          .map((item) => FlashcardItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Note(
      id: json['_id'] ?? '',
      title: json['title'] ?? '제목 없음',
      type: json['type'] ?? '',
      flashcards: parsedFlashcards, // Use the robustly parsed list
      content: json['content'],
      author: json['author'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}