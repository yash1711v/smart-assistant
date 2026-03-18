import 'package:smartassistant/features/suggestions/domain/entities/pagination_info.dart';

/// Data-layer model that extends [PaginationInfo] with JSON deserialization.
///
/// Maps the `pagination` object from the API response to the domain entity.
class PaginationModel extends PaginationInfo {
  /// Creates a [PaginationModel] with all required pagination fields.
  const PaginationModel({
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
    required super.limit,
    required super.hasNext,
    required super.hasPrevious,
  });

  /// Deserializes a [PaginationModel] from a JSON [Map].
  ///
  /// Expects keys matching the API contract: `current_page`, `total_pages`,
  /// `total_items`, `limit`, `has_next`, `has_previous`.
  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      totalItems: json['total_items'] as int,
      limit: json['limit'] as int,
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );
  }
}
