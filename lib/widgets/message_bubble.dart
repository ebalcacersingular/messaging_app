import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String timestamp; // Add timestamp parameter

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp, // Include timestamp in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.75, // Set max width to 75% of screen width
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                timestamp, // Display timestamp below the message
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
