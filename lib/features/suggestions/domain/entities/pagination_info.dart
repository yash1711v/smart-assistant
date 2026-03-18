import 'package:equatable/equatable.dart';

/// Domain entity representing pagination metadata for a paginated response.
///
/// Provides enough information for the presentation layer to decide
/// whether additional pages should be fetched.
class PaginationInfo extends Equatable {
  /// The current page number (1-based).
  final int currentPage;

  /// Total number of pages available.
  final int totalPages;

  /// Total number of items across all pages.
  final int totalItems;

  /// Maximum items returned per page.
  final int limit;

  /// Whether a next page exists beyond [currentPage].
  final bool hasNext;

  /// Whether a previous page exists before [currentPage].
  final bool hasPrevious;

  /// Creates a [PaginationInfo] with all required pagination fields.
  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
    required this.hasNext,
    required this.hasPrevious,
  });

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalItems,
        limit,
        hasNext,
        hasPrevious,
      ];
}
