class Paginated<I> {
  final int currentPage;
  final int lastPage;
  final I data;

  const Paginated({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory Paginated.fromJson(Map<String, dynamic> json, I data) {
    return Paginated(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: data,
    );
  }
}