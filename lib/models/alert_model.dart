enum AlertSeverity { high, attention, review, complete }

class FeedSureAlert {
  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final String category; // "Nutrition", "Storage", "Testing", "Device"
  final DateTime timestamp;
  final String? relatedBatchId;
  final String? targetRoute;
  final bool isRead;

  const FeedSureAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.category,
    required this.timestamp,
    this.relatedBatchId,
    this.targetRoute,
    this.isRead = false,
  });

  FeedSureAlert copyWith({bool? isRead}) {
    return FeedSureAlert(
      id: id,
      title: title,
      message: message,
      severity: severity,
      category: category,
      timestamp: timestamp,
      relatedBatchId: relatedBatchId,
      targetRoute: targetRoute,
      isRead: isRead ?? this.isRead,
    );
  }
}
