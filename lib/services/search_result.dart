class SearchResult {
  final String title;
  final String? description;

  SearchResult({required this.title, this.description});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? '제목 없음',
      description: json['address'] ?? '주소 없음',
    );
  }
}
