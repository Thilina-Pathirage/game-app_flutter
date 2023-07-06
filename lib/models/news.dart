class News {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}
