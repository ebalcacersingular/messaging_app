class Message {
  final int id;
  final String content;
  final DateTime timestamp;
  final String senderUsername;
  final bool isRead;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderUsername,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      senderUsername: json['sender']['username'] as String,
      isRead: json['isRead'] as bool,
    );
  }
}
