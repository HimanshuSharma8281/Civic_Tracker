enum AppScreen {
  splash,
  login,
  register,
  home,
  report,
  confirmation,
  history,
  detail,
  profile,
  notifications,
}

enum ReportStatus {
  submitted,
  inProgress,
  resolved,
}

class Report {
  final String id;
  final String title;
  final String description;
  final String category;
  final ReportStatus status;
  final DateTime createdAt;
  final String location;
  final List<String> photos;
  final String? adminComment;
  final DateTime? updatedAt;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.location,
    required this.photos,
    this.adminComment,
    this.updatedAt,
  });

  String get statusString {
    switch (status) {
      case ReportStatus.submitted:
        return 'submitted';
      case ReportStatus.inProgress:
        return 'in-progress';
      case ReportStatus.resolved:
        return 'resolved';
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String? reportId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    this.reportId,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });
}