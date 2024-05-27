class Message {
  final String messageId;
  final String senderUsername;
  final String receiverUsername;
  final String content;
  final DateTime timestamp;

  Message({
    required this.messageId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      senderUsername: json['senderUsername'],
      receiverUsername: json['receiverUsername'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  toList() {}
}
