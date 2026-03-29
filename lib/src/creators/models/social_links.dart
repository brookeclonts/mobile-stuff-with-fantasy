class SocialLinks {
  const SocialLinks({
    this.tiktok = '',
    this.instagram = '',
    this.threads = '',
    this.facebook = '',
    this.youtube = '',
    this.goodreads = '',
    this.storygraph = '',
    this.website = '',
    this.bookbub = '',
  });

  factory SocialLinks.fromJson(Map<String, Object?> json) {
    return SocialLinks(
      tiktok: json['tiktok'] as String? ?? '',
      instagram: json['instagram'] as String? ?? '',
      threads: json['threads'] as String? ?? '',
      facebook: json['facebook'] as String? ?? '',
      youtube: json['youtube'] as String? ?? '',
      goodreads: json['goodreads'] as String? ?? '',
      storygraph: json['storygraph'] as String? ?? '',
      website: json['website'] as String? ?? '',
      bookbub: json['bookbub'] as String? ?? '',
    );
  }

  final String tiktok;
  final String instagram;
  final String threads;
  final String facebook;
  final String youtube;
  final String goodreads;
  final String storygraph;
  final String website;
  final String bookbub;

  bool get isEmpty =>
      tiktok.isEmpty &&
      instagram.isEmpty &&
      threads.isEmpty &&
      facebook.isEmpty &&
      youtube.isEmpty &&
      goodreads.isEmpty &&
      storygraph.isEmpty &&
      website.isEmpty &&
      bookbub.isEmpty;
}
