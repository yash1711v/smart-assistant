import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/features/history/presentation/cubit/history_cubit.dart';
import 'package:smartassistant/features/history/presentation/cubit/history_state.dart';
import 'package:smartassistant/features/history/presentation/widgets/history_message_tile.dart';

/// Page displaying the full chat history as a scrollable list of messages.
///
/// Integrates with [HistoryCubit] to show loading, loaded,
/// empty, and error states.
class HistoryPage extends StatefulWidget {
  /// Creates a [HistoryPage].
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return switch (state) {
            HistoryInitial() => const SizedBox.shrink(),
            HistoryLoading() => _buildLoading(),
            HistoryLoaded() => _buildLoaded(state),
            HistoryError() => _buildError(context, state),
          };
        },
      ),
    );
  }

  /// Builds a centered loading spinner.
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the loaded message list or an empty state.
  Widget _buildLoaded(HistoryLoaded state) {
    if (state.messages.isEmpty) {
      return _buildEmpty();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        return HistoryMessageTile(chatMessage: state.messages[index]);
      },
    );
  }

  /// Builds an empty-state message.
  Widget _buildEmpty() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No chat history yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation to see it here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an error view with a retry button.
  Widget _buildError(BuildContext context, HistoryError state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<HistoryCubit>().loadHistory(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
