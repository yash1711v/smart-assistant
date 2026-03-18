import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/core/di/injection_container.dart';
import 'package:smartassistant/core/theme/app_theme.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:smartassistant/features/history/presentation/cubit/history_cubit.dart';
import 'package:smartassistant/features/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:smartassistant/features/theme/cubit/theme_cubit.dart';
import 'package:smartassistant/features/theme/cubit/theme_state.dart';
import 'package:smartassistant/features/chat/presentation/pages/chat_page.dart';
import 'package:smartassistant/features/history/presentation/pages/history_page.dart';
import 'package:smartassistant/features/suggestions/presentation/pages/home_page.dart';

/// Root widget of the Smart Assistant application.
///
/// Provides all BLoC/Cubit instances via [MultiBlocProvider] and
/// sets up theming, navigation, and the bottom tab shell.
class SmartAssistantApp extends StatelessWidget {
  /// Creates the [SmartAssistantApp].
  const SmartAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        BlocProvider<SuggestionsCubit>(create: (_) => sl<SuggestionsCubit>()),
        BlocProvider<ChatCubit>(create: (_) => sl<ChatCubit>()),
        BlocProvider<HistoryCubit>(create: (_) => sl<HistoryCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const _AppShell(),
          );
        },
      ),
    );
  }
}

/// Bottom navigation shell that wraps the three main screens.
///
/// Uses [IndexedStack] to preserve each tab's state when switching.
class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  /// The three top-level tab pages.
  final List<Widget> _pages = const [
    HomePage(),
    ChatPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Builds the bottom navigation bar with three tabs.
  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          activeIcon: Icon(Icons.lightbulb),
          label: 'Suggestions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'History',
        ),
      ],
    );
  }
}
