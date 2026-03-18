import 'package:equatable/equatable.dart';

/// State representing the current theme mode of the application.
class ThemeState extends Equatable {
  /// Whether dark mode is currently active.
  final bool isDarkMode;

  /// Creates a [ThemeState] with the given [isDarkMode] flag.
  const ThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}
