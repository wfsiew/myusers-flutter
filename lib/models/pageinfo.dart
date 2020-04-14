class PageInfo {
  int page;
  int perPage;
  int total;
  int totalPages;

  PageInfo({
    this.page,
    this.perPage,
    this.total,
    this.totalPages
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages']
    );
  }
}