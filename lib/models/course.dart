class Course {
  String id;
  String title;
  String description;
  String categoryId;
  int lessons;
  int score;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.lessons,
    required this.score,
  });

  factory Course.fromMap(Map<String, dynamic> m) {
    return Course(
      id: m['id'].toString(),
      title: m['title'] ?? '',
      description: m['description'] ?? '',
      categoryId: m['categoryId'] ?? '',
      lessons: (m['lessons'] is int) ? m['lessons'] : int.tryParse(m['lessons'].toString()) ?? 1,
      score: (m['score'] is int) ? m['score'] : int.tryParse(m['score'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'lessons': lessons,
        'score': score,
      };
}
