class News {
  final int id;
  final String title;
  final String content;
  final String summary;
  final String imageUrl;
  final String category;
  final bool isFeatured;
  final DateTime publishedAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.imageUrl,
    required this.category,
    required this.isFeatured,
    required this.publishedAt,
  });
}