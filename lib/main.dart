import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/screens/login_screen.dart';
import 'package:messaging_app/screens/new_chat_screen.dart';
import 'package:messaging_app/screens/register_screen.dart';
import 'package:messaging_app/screens/friend_request_screen.dart';
import 'package:messaging_app/screens/send_friend_request_screen.dart';
import 'package:messaging_app/screens/user_profile_screen.dart';
import 'package:messaging_app/screens/chat_list_screen.dart';
import 'package:messaging_app/screens/chat_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/friend-requests': (context) => const FriendRequestScreen(),
        '/send-friend-request': (context) => SendFriendRequestScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/chats': (context) => const ChatListScreen(),
        '/new_chat': (context) => const NewChatScreen(),
      },
      // Use onGenerateRoute for routes that require dynamic arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final int chatId =
              settings.arguments as int; // Fetch the chatId from the arguments
          return MaterialPageRoute(
            builder: (context) => ChatScreen(chatId: chatId),
          );
        }
        return null; // Return null if no match is found for the route
      },
    );
  }
}
