import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/services/message_service.dart';
import 'package:messaging_app/models/message.dart';

final messageProvider =
    StateNotifierProvider<MessageNotifier, MessageState>((ref) {
  return MessageNotifier();
});

class MessageState {
  final List<Message> messages;
  final String? errorMessage;
  final bool isLoading;

  MessageState(
      {this.messages = const [], this.errorMessage, this.isLoading = false});

  MessageState copyWith(
      {List<Message>? messages, String? errorMessage, bool? isLoading}) {
    return MessageState(
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MessageNotifier extends StateNotifier<MessageState> {
  MessageNotifier() : super(MessageState());

  final MessageService _messageService = MessageService();

  Future<void> fetchChatMessages(int chatId) async {
    state = state.copyWith(isLoading: true);
    try {
      final messages = await _messageService.getChatMessages(chatId);
      state = state.copyWith(
          messages: messages, isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> sendMessage(int chatId, String content) async {
    try {
      await _messageService.sendMessage(chatId, content);
      fetchChatMessages(chatId); // Refresh messages after sending
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
