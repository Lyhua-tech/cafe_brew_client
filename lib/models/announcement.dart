class Announcement {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? actionUrl;
  final String? type; // e.g. "promotion", "info", "maintenance"
  final String? startDate;
  final String? endDate;
  final bool isActive;

  Announcement({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.actionUrl,
    this.type,
    this.startDate,
    this.endDate,
    this.isActive = true,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
      type: json['type'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      isActive: json['isActive'] ?? true,
    );
  }
}
