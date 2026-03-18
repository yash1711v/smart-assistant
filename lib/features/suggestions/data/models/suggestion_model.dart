import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';

/// Data-layer model that extends [Suggestion] with JSON serialization.
///
/// Bridges the raw API JSON and the domain [Suggestion] entity.
class SuggestionModel extends Suggestion {
  /// Creates a [SuggestionModel] with the required fields.
  const SuggestionModel({
    required super.id,
    required super.title,
    required super.description,
  });

  /// Deserializes a [SuggestionModel] from a JSON [Map].
  ///
  /// Expects keys `id` (int), `title` (String), and `description` (String).
  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  /// Serializes this model to a JSON-compatible [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
