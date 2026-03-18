import 'package:get_it/get_it.dart';
import 'package:smartassistant/core/network/dio_client.dart';
import 'package:smartassistant/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:smartassistant/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:smartassistant/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';
import 'package:smartassistant/features/chat/domain/usecases/get_chat_history.dart';
import 'package:smartassistant/features/chat/domain/usecases/send_message.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:smartassistant/features/history/presentation/cubit/history_cubit.dart';
import 'package:smartassistant/features/suggestions/data/datasources/suggestions_remote_datasource.dart';
import 'package:smartassistant/features/suggestions/data/repositories/suggestions_repository_impl.dart';
import 'package:smartassistant/features/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:smartassistant/features/suggestions/domain/usecases/get_suggestions.dart';
import 'package:smartassistant/features/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:smartassistant/features/theme/cubit/theme_cubit.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Registers all dependencies in the service locator.
///
/// Must be called once before [runApp] in `main.dart`.
/// Registration order: core -> data sources -> repositories ->
/// use cases -> cubits.
Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ── Data Sources ──────────────────────────────────────────────────────
  sl.registerLazySingleton<SuggestionsRemoteDataSource>(
    () => SuggestionsRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSource(),
  );

  // ── Repositories ──────────────────────────────────────────────────────
  sl.registerLazySingleton<SuggestionsRepository>(
    () => SuggestionsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl(), sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<GetSuggestions>(() => GetSuggestions(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
  sl.registerLazySingleton<GetChatHistory>(() => GetChatHistory(sl()));

  // ── Cubits ────────────────────────────────────────────────────────────
  sl.registerFactory<SuggestionsCubit>(() => SuggestionsCubit(sl()));
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      sendMessage: sl(),
      getChatHistory: sl(),
      repository: sl(),
    ),
  );
  sl.registerFactory<HistoryCubit>(
    () => HistoryCubit(repository: sl()),
  );
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
