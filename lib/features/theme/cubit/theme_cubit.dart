import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/features/theme/cubit/theme_state.dart';

/// Cubit managing the app-wide theme mode (light/dark).
///
/// Persists the theme preference to Hive so it survives app restarts.
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates a [ThemeCubit] and initializes with the saved preference.
  ThemeCubit() : super(const ThemeState(isDarkMode: false)) {
    _loadTheme();
  }

  /// Loads the saved theme preference from Hive storage.
  void _loadTheme() {
    final box = Hive.box(AppConstants.hiveThemeBox);
    final isDark = box.get(AppConstants.hiveDarkModeKey, defaultValue: false) as bool;
    emit(ThemeState(isDarkMode: isDark));
  }

  /// Toggles between light and dark mode, persisting the choice.
  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    final box = Hive.box(AppConstants.hiveThemeBox);
    await box.put(AppConstants.hiveDarkModeKey, newValue);
    emit(ThemeState(isDarkMode: newValue));
  }
}
