import 'package:flutter/material.dart';
import 'package:smartassistant/core/theme/app_colors.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

/// A chat bubble widget that visually distinguishes user and assistant messages.
///
/// User messages are right-aligned with the primary bubble color.
/// Assistant messages are left-aligned with a neutral background.
class MessageBubble extends StatelessWidget {
  /// The chat message to display.
  final ChatMessage chatMessage;

  /// Creates a [MessageBubble] for the given [chatMessage].
  const MessageBubble({super.key, required this.chatMessage});

  @override
  Widget build(BuildContext context) {
    final isUser = chatMessage.sender == 'user';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: _bubbleColor(isUser: isUser, isDark: isDark),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          chatMessage.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
        ),
      ),
    );
  }

  /// Returns the appropriate bubble background color based on sender and theme.
  Color _bubbleColor({required bool isUser, required bool isDark}) {
    if (isUser) return AppColors.userBubble;
    return isDark
        ? AppColors.assistantBubbleDark
        : AppColors.assistantBubbleLight;
  }
}
