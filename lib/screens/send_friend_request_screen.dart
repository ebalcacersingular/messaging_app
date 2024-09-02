import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/friend_request_provider.dart';

class SendFriendRequestScreen extends ConsumerWidget {
  final TextEditingController _usernameController = TextEditingController();

  SendFriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequestNotifier = ref.read(friendRequestProvider.notifier);
    final friendRequestState = ref.watch(friendRequestProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Send Friend Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (friendRequestState.errorMessage != null)
              Text(friendRequestState.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Enter Username'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => friendRequestNotifier
                  .sendFriendRequest(_usernameController.text),
              child: const Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
