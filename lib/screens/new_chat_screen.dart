import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/chat_provider.dart';

class NewChatScreen extends ConsumerWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNotifier = ref.read(chatProvider.notifier);
    final TextEditingController userController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start New Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Enter username or email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Start a new chat with the entered user
                  await chatNotifier.startNewChat(userController.text.trim());
                  Navigator.of(context)
                      .pop(); // Go back to the chat list screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Start Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
