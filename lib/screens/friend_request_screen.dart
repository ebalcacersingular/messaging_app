import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/friend_request_provider.dart';
import 'package:messaging_app/screens/send_friend_request_screen.dart';

class FriendRequestScreen extends ConsumerWidget {
  const FriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequestState = ref.watch(friendRequestProvider);
    final friendRequestNotifier = ref.read(friendRequestProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendFriendRequestScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (friendRequestState.errorMessage != null)
              Text(friendRequestState.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: friendRequestNotifier.fetchPendingRequests,
              child: const Text('Refresh Requests'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: friendRequestState.pendingRequests.length,
                itemBuilder: (ctx, index) {
                  final request = friendRequestState.pendingRequests[index];
                  return ListTile(
                    title: Text(request.senderUsername),
                    subtitle: Text('Status: ${request.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => friendRequestNotifier
                              .respondToFriendRequest(request.id, 'accepted'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => friendRequestNotifier
                              .respondToFriendRequest(request.id, 'rejected'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
