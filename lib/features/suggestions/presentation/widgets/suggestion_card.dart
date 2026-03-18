import 'package:flutter/material.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';

/// A material card that displays a [Suggestion]'s title and description.
///
/// Uses the current [Theme] for all styling so it adapts automatically
/// to light/dark mode. Supports an optional [onTap] callback.
class SuggestionCard extends StatelessWidget {
  /// The suggestion entity to display.
  final Suggestion suggestion;

  /// Optional callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a [SuggestionCard] for the given [suggestion].
  const SuggestionCard({
    super.key,
    required this.suggestion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suggestion.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                suggestion.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
