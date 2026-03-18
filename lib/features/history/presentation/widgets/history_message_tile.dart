import 'package:flutter/material.dart';
import 'package:smartassistant/core/theme/app_colors.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

/// A tile widget displaying a single message from the chat history.
///
/// Differentiates between user and assistant messages with distinct
/// icons, colors, and alignment.
class HistoryMessageTile extends StatelessWidget {
  /// The chat message to display.
  final ChatMessage chatMessage;

  /// Creates a [HistoryMessageTile] for the given [chatMessage].
  const HistoryMessageTile({super.key, required this.chatMessage});

  /// Whether this message was sent by the user.
  bool get _isUser => chatMessage.sender == 'user';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isUser
            ? (isDark ? AppColors.userBubble.withValues(alpha: 0.15) : AppColors.userBubble.withValues(alpha: 0.08))
            : theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isUser
              ? AppColors.userBubble.withValues(alpha: 0.3)
              : theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(theme),
          const SizedBox(width: 12),
          Expanded(child: _buildContent(theme)),
        ],
      ),
    );
  }

  /// Builds the sender avatar icon.
  Widget _buildAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: _isUser
          ? AppColors.userBubble
          : theme.colorScheme.secondaryContainer,
      child: Icon(
        _isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
        size: 18,
        color: _isUser
            ? Colors.white
            : theme.colorScheme.onSecondaryContainer,
      ),
    );
  }

  /// Builds the sender label and message text.
  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isUser ? 'You' : 'Assistant',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _isUser
                ? AppColors.userBubble
                : theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          chatMessage.message,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
