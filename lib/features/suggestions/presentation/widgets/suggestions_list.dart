import 'package:flutter/material.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';
import 'package:smartassistant/features/suggestions/presentation/widgets/suggestion_card.dart';

/// A scrollable list of [SuggestionCard] widgets with infinite-scroll support.
///
/// Automatically triggers [onLoadMore] when the user scrolls near the
/// bottom and [hasMore] is `true`.
class SuggestionsList extends StatefulWidget {
  /// The suggestions to display.
  final List<Suggestion> suggestions;

  /// Whether additional items are currently being fetched.
  final bool isLoadingMore;

  /// Whether more pages are available to load.
  final bool hasMore;

  /// Callback invoked when the user scrolls near the bottom.
  final VoidCallback onLoadMore;

  /// Creates a [SuggestionsList].
  const SuggestionsList({
    super.key,
    required this.suggestions,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  State<SuggestionsList> createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Detects when the user is within 200px of the bottom and
  /// triggers pagination if more data is available.
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    const scrollThreshold = 200.0;

    if (maxScroll - currentScroll <= scrollThreshold && widget.hasMore) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.suggestions.length + (widget.isLoadingMore ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= widget.suggestions.length) {
          return _buildLoadingIndicator();
        }
        return SuggestionCard(suggestion: widget.suggestions[index]);
      },
    );
  }

  /// Builds a centered progress indicator shown at the bottom
  /// while additional pages are being fetched.
  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
