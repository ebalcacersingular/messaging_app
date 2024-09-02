import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/chat_provider.dart';
import 'package:messaging_app/providers/auth_provider.dart';
import 'package:messaging_app/screens/chat_screen.dart';
import 'package:messaging_app/screens/friend_request_screen.dart';
import 'package:messaging_app/screens/new_chat_screen.dart';
import 'package:messaging_app/screens/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).fetchUserChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendRequestScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(chatProvider.notifier).fetchUserChats();
        },
        child: chatState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: chatState.chats.length,
                itemBuilder: (ctx, index) {
                  final chat = chatState.chats[index];
                  // Get the other user's username
                  final otherUser = chat.participants.firstWhere(
                      (participant) => participant.uid != currentUser?.uid);

                  final lastMessage = chat.lastMessage;
                  return ListTile(
                    title: Text(
                      otherUser
                          .username, // Display only the other user's username
                    ),
                    subtitle: lastMessage != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lastMessage.content,
                                maxLines: 1, // Limit to one line
                                overflow: TextOverflow
                                    .ellipsis, // Truncate with ellipsis
                                style: const TextStyle(
                                  color: Colors
                                      .black54, // Optional: style for the last message text
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      4), // Add some space between text and timestamp
                              Text(
                                timeago.format(lastMessage
                                    .timestamp), // Display formatted time
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Style for timestamp
                                ),
                              ),
                            ],
                          )
                        : const Text('No messages yet'),
                    onTap: () {
                      ref.read(chatProvider.notifier).fetchChatDetails(chat.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatId: chat.id),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
