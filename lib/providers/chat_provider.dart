import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/services/chat_service.dart';
import 'package:messaging_app/models/chat.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatState {
  final List<Chat> chats;
  final Chat? currentChat;
  final String? errorMessage;
  final bool isLoading;

  ChatState(
      {this.chats = const [],
      this.currentChat,
      this.errorMessage,
      this.isLoading = false});

  ChatState copyWith({
    List<Chat>? chats,
    Chat? currentChat,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      currentChat: currentChat ?? this.currentChat,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  final ChatService _chatService = ChatService();

  Future<void> fetchUserChats() async {
    state = state.copyWith(isLoading: true);
    try {
      final chats = await _chatService.fetchChats();
      print("Chats from Provider: ${chats}");
      state =
          state.copyWith(chats: chats, isLoading: false, errorMessage: null);
    } catch (e) {
      print("Error in Provider: $e");
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchChatDetails(int chatId) async {
    state = state.copyWith(isLoading: true);
    try {
      final chat = await _chatService.fetchExistingChat(chatId);
      state = state.copyWith(
          currentChat: chat, isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> startNewChat(String userId) async {
    state = state.copyWith(isLoading: true);

    try {
      final newChat = await _chatService.createChat(userId);
      state = state.copyWith(
          chats: [...state.chats, newChat],
          isLoading: false,
          errorMessage: null);
      fetchUserChats();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}
