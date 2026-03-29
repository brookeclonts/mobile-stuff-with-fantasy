class Review {
  const Review({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.rating,
    required this.title,
    required this.body,
    required this.createdAt,
    this.updatedAt,
    this.bookTitle = '',
    this.bookAuthor = '',
    this.bookImageUrl = '',
  });

  final String id;
  final String userId;
  final String bookId;
  final int rating;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String bookTitle;
  final String bookAuthor;
  final String bookImageUrl;

  factory Review.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return Review(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      bookId: (map['bookId'] ?? '').toString(),
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      bookTitle: map['bookTitle']?.toString() ?? '',
      bookAuthor: map['bookAuthor']?.toString() ?? '',
      bookImageUrl: map['bookImageUrl']?.toString() ?? '',
    );
  }
}
