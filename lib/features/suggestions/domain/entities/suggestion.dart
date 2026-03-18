import 'package:equatable/equatable.dart';

/// Domain entity representing a single suggestion prompt.
///
/// Used across the domain and presentation layers as the canonical
/// representation of a suggestion returned by the API.
class Suggestion extends Equatable {
  /// Unique server-assigned identifier.
  final int id;

  /// Short display title for the suggestion.
  final String title;

  /// Longer explanatory text describing the suggestion.
  final String description;

  /// Creates a [Suggestion] with the required [id], [title], and [description].
  const Suggestion({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}
