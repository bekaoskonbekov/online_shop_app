import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String type; // 'like', 'comment', 'follow', etc.
  final String fromUserId;
  final String toUserId;
  final String postId;
  final DateTime timestamp;

  NotificationModel({
    required this.notificationId,
    required this.type,
    required this.fromUserId,
    required this.toUserId,
    required this.postId,
    required this.timestamp,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      notificationId: data['notificationId'] ?? '',
      type: data['type'] ?? '',
      fromUserId: data['fromUserId'] ?? '',
      toUserId: data['toUserId'] ?? '',
      postId: data['postId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'type': type,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'postId': postId,
      'timestamp': timestamp,
    };
  }
}
