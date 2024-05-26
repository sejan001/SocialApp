class FriendModel {
  String username;
  String friendUsername;
  String requestedByUsername;
  DateTime createdAt;
  bool hasNewRequest;
  bool hasNewRequestAccepted;
  bool hasRemoved;

  FriendModel({
    required this.username,
    required this.friendUsername,
    required this.requestedByUsername,
    required this.createdAt,
    required this.hasNewRequest,
    required this.hasNewRequestAccepted,
    required this.hasRemoved,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      username: json['username'],
      friendUsername: json['friend_username'],
      requestedByUsername: json['requested_by_username'],
      createdAt: DateTime.parse(json['created_at']),
      hasNewRequest: json['has_new_request'],
      hasNewRequestAccepted: json['has_new_request_accepted'],
      hasRemoved: json['has_removed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'friend_username': friendUsername,
      'requested_by_username': requestedByUsername,
      'created_at': createdAt.toIso8601String(),
      'has_new_request': hasNewRequest,
      'has_new_request_accepted': hasNewRequestAccepted,
      'has_removed': hasRemoved,
    };
  }
}
