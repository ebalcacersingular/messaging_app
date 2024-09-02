class FriendRequest {
  final int id;
  final String senderUsername;
  final String status;

  FriendRequest({
    required this.id,
    required this.senderUsername,
    required this.status,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      senderUsername: json['sender']
          ['username'], // Assuming the sender is nested
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUsername': senderUsername,
      'status': status,
    };
  }
}
