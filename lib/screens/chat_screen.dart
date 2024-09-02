import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/message_provider.dart';
import 'package:messaging_app/providers/auth_provider.dart';
import 'package:messaging_app/widgets/message_bubble.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends ConsumerStatefulWidget {
  final int chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messageNotifier = ref.read(messageProvider.notifier);
      messageNotifier.fetchChatMessages(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageProvider);
    final messageNotifier = ref.read(messageProvider.notifier);

    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: messageState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messageState.messages.length,
                    itemBuilder: (ctx, index) {
                      final message = messageState.messages[index];
                      return MessageBubble(
                        message: message.content,
                        isMe: message.senderUsername == currentUser?.username,
                        timestamp: timeago
                            .format(message.timestamp), // Format timestamp
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    messageNotifier.sendMessage(
                        widget.chatId, _messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
