import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_state.dart';
import 'package:smartassistant/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:smartassistant/features/chat/presentation/widgets/message_bubble.dart';

/// Full-screen chat page displaying the conversation and a message input.
///
/// Loads cached + remote history on init, auto-scrolls on new messages,
/// and shows a typing indicator while the assistant is responding.
class ChatPage extends StatefulWidget {
  /// Creates a [ChatPage].
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls the list to the bottom after the current frame renders.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInput(),
        ],
      ),
    );
  }

  /// Builds the scrollable message list with a typing indicator.
  Widget _buildMessageList() {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) _scrollToBottom();
      },
      builder: (context, state) {
        if (state is ChatInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        final loaded = state as ChatLoaded;
        if (loaded.messages.isEmpty) {
          return Center(
            child: Text(
              'No messages yet. Say hello!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          itemCount: loaded.messages.length + (loaded.isSending ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == loaded.messages.length && loaded.isSending) {
              return _buildTypingIndicator();
            }
            return MessageBubble(chatMessage: loaded.messages[index]);
          },
        );
      },
    );
  }

  /// Builds the bottom input field, disabled while a message is in flight.
  Widget _buildInput() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final isSending = state is ChatLoaded && state.isSending;
        return ChatInputField(
          isEnabled: !isSending,
          onSend: (message) => context.read<ChatCubit>().sendMessage(message),
        );
      },
    );
  }

  /// Displays a left-aligned typing indicator while awaiting a reply.
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thinking...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
