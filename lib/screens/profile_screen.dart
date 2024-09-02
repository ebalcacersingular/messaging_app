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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userNotifier = ref.read(userProvider.notifier);
    await userNotifier.fetchUserDetails();

    final userState = ref.read(userProvider);
    if (userState.user != null) {
      _emailController.text = userState.user!.email!;
      _usernameController.text = userState.user!.username!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                userNotifier.updateUserProfile(
                  _emailController.text,
                  _usernameController.text,
                );
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (userState.errorMessage != null)
                    Text(
                      userState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        userNotifier.updateUserProfile(
                          _emailController.text,
                          _usernameController.text,
                        );
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Save Changes'),
                    ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
