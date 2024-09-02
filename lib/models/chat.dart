import 'package:messaging_app/models/message.dart';

class Chat {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  List<Participant> participants;
  List<Message> messages;
  Message? lastMessage;

  Chat({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
    required this.messages,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      participants: (json['participants'] as List<dynamic>)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((message) => Message.fromJson(message))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class Participant {
  String uid;
  String email;
  String username;

  Participant({
    required this.uid,
    required this.email,
    required this.username,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }
}
