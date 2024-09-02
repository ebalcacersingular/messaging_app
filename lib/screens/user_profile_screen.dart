import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/user_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userNotifier = ref.read(userProvider.notifier);
    userNotifier.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    if (userState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userState.user != null) {
      _emailController.text = userState.user!.email!;
      _usernameController.text = userState.user!.username!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (userState.errorMessage != null)
              Text(userState.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => userNotifier.updateUserProfile(
                _emailController.text,
                _usernameController.text,
              ),
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
