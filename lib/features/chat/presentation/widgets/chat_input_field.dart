import 'package:flutter/material.dart';

/// A text input field with a send button for composing chat messages.
///
/// Clears the text field after sending and disables input while
/// [isEnabled] is `false` (e.g. during message transmission).
class ChatInputField extends StatefulWidget {
  /// Callback invoked with the trimmed message text when the user taps send.
  final void Function(String) onSend;

  /// Whether the input field and send button are interactive.
  final bool isEnabled;

  /// Creates a [ChatInputField] with the required [onSend] callback
  /// and [isEnabled] flag.
  const ChatInputField({
    super.key,
    required this.onSend,
    required this.isEnabled,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Sends the current text if non-empty, then clears the field.
  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.isEnabled,
                textInputAction: TextInputAction.send,
                onSubmitted: widget.isEnabled ? (_) => _handleSend() : null,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.isEnabled ? _handleSend : null,
              icon: Icon(
                Icons.send_rounded,
                color: widget.isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
